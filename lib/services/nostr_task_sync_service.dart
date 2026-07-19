import '../models/sync_config_model.dart';
import '../models/task_model.dart';
import '../models/user_model.dart';
import '../utils/logger.dart';
import 'nostr_service.dart';
import 'task_local_storage_service.dart';

/// Encrypted, offline-first sync of tasks to Nostr relays — the default sync
/// channel. It follows the same orchestration as Astraea's calendar sync.
///
/// Orchestrates the local store and [NostrService]; the actual NIP-44
/// encryption + signing (local key or Amber) live in [NostrService], so this
/// layer is identity-agnostic — it just passes the signed-in [User] through.
///
/// Design:
///  - Each [Task] → NIP-44 self-encrypted → kind-30789 with `d` tag
///    stable legacy wire tag `checkmarks:<id>` (parameterized replaceable:
///    same `d` tag, and the relay keeps only the latest).
///  - Delete = NIP-09 deletion request + a local `deleted` tombstone (relays
///    may ignore deletions, so the local flag wins).
///  - Sync = REQ for the user's kind-30789 events with the `checkmarks:`
///    `d`-tag prefix, decrypt, merge last-write-wins on `updatedAt`, then
///    push any locally-unsynced tasks and pending deletions.
///
class NostrTaskSyncService {
  NostrTaskSyncService({
    required TaskLocalStorageService taskStorage,
    required NostrService nostrService,
  }) : _storage = taskStorage,
       _nostr = nostrService;

  final TaskLocalStorageService _storage;
  final NostrService _nostr;

  /// Encrypts and publishes a single task, then persists it as synced.
  Future<void> publishTask(
    Task task, {
    required SyncConfig config,
    required User author,
  }) async {
    if (task.localOnly) {
      throw StateError('A local-only task must never be published.');
    }
    SyncLog.nostr('publishTask ${task.id} (kind 30789, d=${task.dTag})');
    final owned = await _claimForAuthor(task, author);
    final eventId = await _nostr.publishTask(
      author: author,
      task: owned,
      relayUrls: config.allSyncRelays,
      homeRelayUrl: config.homeRelayUrl,
    );
    await _storage.markSyncedIfCurrent(
      owned,
      eventId: eventId,
      ownerPubkey: author.publicKeyHex,
      clearDeletionRequestPending: true,
    );
  }

  /// Pulls and decrypts every Kairos task of [author] from the relays.
  Future<List<Task>> fetchTasksFromRelay({
    required SyncConfig config,
    required User author,
  }) async {
    SyncLog.nostr(
      'fetchTasksFromRelay from ${config.allSyncRelays.length} relay(s)',
    );
    return _nostr.fetchTasks(
      author: author,
      relayUrls: config.allSyncRelays,
      homeRelayUrl: config.homeRelayUrl,
    );
  }

  /// Propagates a deletion. [task] must already be the local tombstone
  /// (`deleted: true`).
  ///
  /// Two mechanisms, deliberately redundant: the encrypted tombstone is
  /// republished under the same `d` tag (a replaceable event, so every relay
  /// overwrites the old content and every other device merges `deleted: true`
  /// on its next sync), and a NIP-09 deletion request asks relays to drop the
  /// record entirely. NIP-09 alone is not enough — relays may ignore it, and
  /// then the other devices would happily resurrect the task.
  Future<void> deleteTask(
    Task task, {
    required SyncConfig config,
    required User author,
  }) async {
    SyncLog.nostr('deleteTask ${task.id}');
    final relays = config.allSyncRelays;
    final owned = await _claimForAuthor(task, author);
    final previousEventId = owned.nostrEventId;
    final eventId = await _nostr.publishTask(
      author: author,
      task: owned,
      relayUrls: relays,
      homeRelayUrl: config.homeRelayUrl,
    );
    if (previousEventId != null) {
      await _nostr.publishDeletion(
        author: author,
        nostrEventId: previousEventId,
        relayUrls: relays,
        homeRelayUrl: config.homeRelayUrl,
      );
    }
    await _storage.markSyncedIfCurrent(
      owned,
      eventId: eventId,
      ownerPubkey: author.publicKeyHex,
      clearDeletionRequestPending: true,
    );
  }

  /// Full sync cycle: pull + decrypt, merge last-write-wins by `updatedAt`,
  /// then push locally-unsynced tasks (and pending deletions). Returns how
  /// many local tasks changed.
  Future<int> runSyncCycle({
    required SyncConfig config,
    required User author,
  }) async {
    SyncLog.nostr('runSyncCycle');
    final incoming = await fetchTasksFromRelay(config: config, author: author);

    final existingById = {for (final t in await _storage.loadTasks()) t.id: t};
    var changed = 0;
    for (final task in incoming) {
      if (await mergeIncoming(task, existingById: existingById)) {
        existingById[task.id] = task;
        changed++;
      }
    }

    var pushFailures = 0;
    for (final local in existingById.values) {
      if (local.synced) continue;
      // Explicitly pinned to this device: neither the task nor its
      // tombstone ever goes out.
      if (local.localOnly) continue;
      final owner = local.syncOwnerPubkey;
      if (owner != null && owner != author.publicKeyHex) {
        SyncLog.warn(
          'NOSTR',
          'Skipped a task belonging to another sync account',
        );
        continue;
      }
      try {
        if (local.deleted && local.deletionRequestPending) {
          await deleteTask(local, config: config, author: author);
        } else {
          await publishTask(local, config: config, author: author);
        }
      } catch (e) {
        pushFailures++;
        SyncLog.warn('NOSTR', 'Failed to push one task');
        // Leave it unsynced; the next cycle retries it.
      }
    }
    if (pushFailures > 0) {
      throw StateError('Could not publish $pushFailures task(s).');
    }
    return changed;
  }

  /// Merges one decrypted incoming task into local storage using
  /// last-write-wins on [Task.updatedAt]. Returns whether local changed.
  Future<bool> mergeIncoming(
    Task incoming, {
    required Map<String, Task> existingById,
  }) async {
    final existing = existingById[incoming.id];
    if (existing == null || incoming.updatedAt.isAfter(existing.updatedAt)) {
      await _storage.saveTask(incoming);
      return true;
    }
    return false;
  }

  /// Binds a local revision to an account before any network request. If a
  /// publish fails and the user later changes account, the pending plaintext
  /// task must not be silently uploaded under that different identity.
  Future<Task> _claimForAuthor(Task task, User author) async {
    final current = _storage.getTask(task.id);
    if (current == null || current.updatedAt != task.updatedAt) {
      throw StateError('Task revision was superseded before publication.');
    }
    final owner = current.syncOwnerPubkey;
    if (owner != null && owner != author.publicKeyHex) {
      throw StateError('Task belongs to a different sync account.');
    }
    if (owner != null) return current;
    final claimed = current.copyWith(syncOwnerPubkey: author.publicKeyHex);
    await _storage.saveTask(claimed);
    return claimed;
  }
}
