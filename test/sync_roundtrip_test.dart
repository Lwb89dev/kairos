import 'dart:convert';

import 'package:dart_nostr/dart_nostr.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kairos/models/task_model.dart';
import 'package:kairos/utils/constants.dart';
import 'package:kairos/utils/crypto.dart';
import 'package:kairos/utils/nostr_timestamp.dart';

/// End-to-end wire round trip: sign a task event exactly as
/// `NostrService.publishTask` does, serialize it to the relay wire format,
/// deserialize it exactly as `dart_nostr` does for incoming EVENT frames,
/// then run the same authenticity/decrypt/parse gauntlet `fetchTasks` runs.
/// Any asymmetry between the publish and fetch paths fails here instead of
/// silently dropping events in production.
void main() {
  final nostr = Nostr.instance;

  Task buildTask(DateTime updatedAt) => Task(
    id: 'e6f2b9a4-0000-4000-8000-123456789abc',
    title: 'Round trip me',
    description: 'created on device A, restored on device B',
    dueDateUtc: DateTime.utc(2026, 8, 1, 12),
    tags: const ['work'],
    priority: 3,
    createdAt: DateTime.utc(2026, 7, 19, 10, 0, 0),
    updatedAt: updatedAt,
  );

  /// Mirrors `NostrService._isAuthenticEvent`.
  bool isAuthentic(NostrEvent event, String author) {
    final id = event.id;
    final content = event.content;
    final createdAt = event.createdAt;
    final tags = event.tags;
    if (id == null || content == null || createdAt == null || tags == null) {
      return false;
    }
    if (event.pubkey != author || event.kind != AppConstants.taskEventKind) {
      return false;
    }
    final computedId = NostrEvent.getEventId(
      kind: AppConstants.taskEventKind,
      content: content,
      createdAt: createdAt,
      tags: tags,
      pubkey: event.pubkey,
    );
    return computedId == id && event.isVerified();
  }

  NostrEvent roundTripThroughRelay(NostrEvent signed) {
    // What `sendEventToRelaysAsync` puts on the wire...
    final wire = signed.serialized();
    final asList = jsonDecode(wire) as List<dynamic>;
    final eventMap = asList.last as Map<String, dynamic>;
    // ...is what a relay stores and echoes back inside an EVENT frame.
    final relayFrame = jsonEncode(['EVENT', 'sub-id', eventMap]);
    return NostrEvent.deserialized(relayFrame);
  }

  for (final (label, updatedAt) in [
    // createTask stamps DateTime.now().toUtc() — sub-second precision.
    (
      'sub-second updatedAt (createTask path)',
      DateTime.utc(2026, 7, 19, 10, 0, 0, 123, 456),
    ),
    // upsert stamps nextNostrTimestamp() — whole-second precision.
    (
      'whole-second updatedAt (upsert path)',
      nextNostrTimestamp(DateTime.utc(2026, 7, 19, 10, 0, 0)),
    ),
  ]) {
    test('publish → relay wire → fetch round trip survives: $label', () {
      final keyPair = nostr.services.keys.generateKeyPair();
      final task = buildTask(updatedAt);

      // --- Publish side (mirrors NostrService.publishTask/_signEvent) ---
      final content = CryptoUtils.encryptNip44(
        plaintext: jsonEncode(task.toSyncJson()),
        privateKeyHex: keyPair.private,
        recipientPublicKeyHex: keyPair.public,
      );
      final signed = NostrEvent.fromPartialData(
        kind: AppConstants.taskEventKind,
        content: content,
        keyPairs: keyPair,
        tags: [
          ['d', task.dTag],
        ],
        createdAt: task.updatedAt,
      );

      // --- Wire round trip (relay echoes the event back) ---
      final received = roundTripThroughRelay(signed);

      // --- Fetch side (mirrors NostrService.fetchTasks) ---
      expect(
        isAuthentic(received, keyPair.public),
        isTrue,
        reason: 'event must re-verify after the relay wire round trip',
      );
      final dTag = received.tags!.firstWhere(
        (tag) => tag.length >= 2 && tag[0] == 'd',
      )[1];
      expect(dTag, startsWith(AppConstants.dTagPrefix));

      final plaintext = CryptoUtils.decryptNip44(
        ciphertext: received.content!,
        privateKeyHex: keyPair.private,
        senderPublicKeyHex: keyPair.public,
      );
      final restored = Task.fromJson(
        jsonDecode(plaintext) as Map<String, dynamic>,
      );
      expect(restored.dTag, dTag);
      expect(restored.title, task.title);
      expect(restored.description, task.description);
      expect(restored.dueDateUtc, task.dueDateUtc);
      expect(restored.tags, task.tags);
      expect(restored.priority, task.priority);
      expect(restored.updatedAt, task.updatedAt);
    });
  }
}
