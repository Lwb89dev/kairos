# Kairos architecture

Kairos follows four invariants:

1. A task mutation succeeds locally before any network operation begins.
2. No task content leaves the device without NIP-44 encryption.
3. No network endpoint is selected implicitly on a fresh install.
4. Untrusted relay input is bounded and authenticated before decryption.

## Layers

- `models` contain immutable task, user, profile and relay configuration data.
- `services` own encrypted Hive persistence, secure-storage access and Nostr protocol operations.
- `providers` orchestrate local-first mutations, sync and UI state with Riverpod.
- `screens` render state and collect bounded, validated user input.

## Storage

The task database uses Hive AES-256 encryption with a random 32-byte key kept
in platform secure storage. On first start after the rename, records from the
old plaintext `checkmarks_tasks` box are copied into `kairos_tasks_v1`, flushed,
verified by key and only then is the plaintext box removed. Account keys use a
separate secure-storage entry. Non-secret settings remain in SharedPreferences.

## Nostr representation

Each task is a kind `30789` parameterized-replaceable event. The `d` tag keeps
the historical `checkmarks:<uuid>` namespace for wire compatibility. All task
fields remain inside NIP-44 ciphertext; no title, due date, tag, priority or
status is exposed as a Nostr tag. Sync verifies event IDs/signatures, matches
the decrypted task ID back to the `d` tag, then performs last-write-wins using a
timestamp that advances monotonically at Nostr's whole-second resolution.

Deletion publishes a newer encrypted tombstone and asks relays to retract only
the preceding concrete event. The tombstone is intentionally left fetchable.
Pending revisions are bound to an account before the network request begins,
and transport fan-out is capped at 12 unique secure relay endpoints.

## Task reminders

Reminders are offsets before a task's due date, stored on the task itself
(`Task.reminders`) and therefore synchronized to the account's other devices
like any other task field. A task without a due date cannot hold reminders:
there would be nothing to count back from, and the invariant is enforced in
`Task.fromJson` and `Task.copyWith` rather than trusted.

`NotificationService` hands each reminder to the OS with
`flutter_local_notifications`' `zonedSchedule()` when the task is saved. There
is no polling and no background service — the app is not running when a
reminder fires. The fire instant is resolved through the device's IANA
timezone (seeded in `main()`), so a DST change between scheduling and delivery
does not move the notification.

Every write is idempotent: scheduling cancels whatever the task had before, so
an edit cannot leave a stale alarm behind. The mapping from task id to OS
notification ids lives in `LocalStorageService`, which is what lets one task
cancel exactly its own alarms and no one else's. Alarms are OS state that can
disappear without the app being told (an update, cleared data, a permission
granted late, a task that arrived from another device), so the whole set is
rebuilt on every app open and again after a relay sync.

Failure is always non-fatal. A denied notification or exact-alarm permission
costs the user a reminder, never their data: the task saves either way.

## Astraea calendar integration

A task with a due date can also appear in the calendar — and the home-screen
widget — of Astraea, the sibling calendar app, without the two apps sharing
anything locally.

Kairos sends the event locally on Android as well as publishing it to Nostr.
The local message is an explicit, versioned JSON instruction containing the
event and a notification command; Astraea writes it through its normal local
store and must deduplicate the notification. See
`docs/ASTRAEA_LOCAL_PROTOCOL.md` for the receiver contract. The relays remain
the durable cross-device path. Astraea stores its calendar as kind-30078
(NIP-78 application data) parameterized-replaceable events under the
`d` tag `epochs:<uuid>`, NIP-44 self-encrypted with the account's key. Kairos
holds that same key, so `AstraeaCalendarMirror` can write an event in exactly
that shape. Astraea's next sync pulls it like any other event, saves it, and
redraws its widgets from that local copy — which is why the widget requirement
needs no code here at all.

Design points worth stating:

- **Opt-in per task.** Publishing a second document for a task is a decision
  about what leaves the device, so it is never made on the user's behalf. A
  local-only task is excluded unconditionally.
- **Deterministic coordinate.** The `d` tag is derived from the task id, so an
  edited task replaces its own calendar event instead of accumulating copies,
  and no extra state has to be kept in sync to find it again.
- **One-way.** Kairos never reads Astraea's events. A mirror that cannot read
  cannot corrupt the user's calendar. The cost is that an edit made to the
  mirrored event inside Astraea is overwritten the next time the task changes
  in Kairos: the task is the source of truth for its own mirror.
- **Non-fatal and retryable.** The calendar entry is written after the task is
  already safely on the relays, and a failure is logged rather than propagated.
  Missing mirrors and failed retractions remain detectable through local
  bookkeeping and are retried by the next sync.
