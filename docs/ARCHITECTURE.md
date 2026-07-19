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
