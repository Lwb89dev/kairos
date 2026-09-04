# Changelog

All notable changes to Kairos are documented in this file. The format is based
on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project
adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-09-04

The first stable release of Kairos. 🎉

### Added

- A complete Kairos visual and UX revamp built around the "Time through Glass"
  design language: atmospheric backgrounds, bounded translucent surfaces,
  precise typography and restrained depth in both dark and light themes.
- A tactile completion control with immediate state changes and a short visual
  check animation.
- A lightweight task-list layout that keeps titles fast to scan while making
  due dates, reminders, priorities, tags, sync and Astraea state easier to
  understand.
- A reusable visual foundation for glass surfaces, section headers, completion
  controls and the primary task-creation action.
- Refined onboarding, task editor, task details, settings and empty states.

### Changed

- Dark mode is now intentionally designed as a near-black atmospheric surface,
  while light mode uses luminous cool neutrals instead of sterile white.
- Task colors now act as restrained semantic indicators rather than filling
  every task row with a heavy card background.
- Blur is limited to bounded interactive surfaces so the scrolling task list
  remains lightweight.

### Preserved

- Offline-first behavior, encrypted local storage and secure key handling.
- Optional encrypted Nostr synchronization and relay security restrictions.
- Reminders, task status behavior, NIP-09 deletion semantics and
  Astraea calendar mirroring.
- All 27 localizations and the existing Android application identity.

## [0.1.3] - 2026-08-25

### Fixed

- The Android adaptive app icon: the foreground artwork was scaled to only
  60% of the canvas and sat on a background color dark enough to read as
  flat black, so the launcher showed a large near-black ring around a small
  icon. The foreground is now cropped to its actual opaque bounds and
  rescaled to 72%, and the background color is a lighter mid-purple that
  reads as part of the design rather than as a rendering bug.

## [0.1.2] - 2026-08-20

### Added

- A "Sync to Nostr" toggle for tasks that are already syncing, not just new
  ones: switching it off in the editor pins the task to this device and
  retracts its existing relay copy (and calendar mirror, if mirrored);
  switching it back on resumes publishing. Complements the existing "Sync
  task" action, which already covered the opposite direction for a task
  created local-only.

### Fixed

- The Android app icon: the source artwork's own rounded-square edges reached
  the adaptive-icon safe zone boundary, so circular or squircle launcher masks
  cropped the glyph. The foreground layer is now generated with enough padding
  to sit fully inside the mask on every launcher shape.

## [0.1.1] - 2026-07-28

### Added

- Task reminders. A task with a due date can carry several notifications
  ("at the due time", 5/15/30 minutes, 1/2 hours or 1 day before); setting a
  deadline for the first time adds a one-hour reminder that can be changed or
  removed. Reminders are handed to the system when the task is saved and
  delivered by it, so nothing runs in the background, and they follow the task
  to the account's other devices. A single switch in Settings turns them all
  off and back on without losing the per-task choices.
- Astraea calendar integration. A dated task can be published as an Astraea
  calendar event, so it appears in that app's calendar and home-screen widget
  on the day it is due. Opt-in per task, from the editor. When both apps are
  installed, Kairos also sends Astraea a local instruction with an explicit
  notification request, independently of Nostr.
- Local Kairos ↔ Astraea interoperability. Android uses an explicit,
  package-bound intent; Linux uses a per-user Unix-domain socket. Upserts,
  edits, unchecks and deletions are delivered through a versioned JSON
  protocol, with notification deduplication instructions for Astraea.
- The Astraea calendar option is now available for dated tasks even without a
  Nostr account or selected relay; the local bridge works offline and Nostr
  remains the durable cross-device channel when configured.
- Four more suggested relays (`relay.primal.net`, `relay.nostr.band`,
  `nostr.mom`, `relay.snort.social`) alongside the existing two, for
  redundancy when one is slow or unreachable. As before, none is selected
  unless the user taps it.
- Relays on the local network can now be added to the ordinary relay list,
  not only to the dedicated home-relay slot, over `wss://` or plaintext
  `ws://`. Plaintext remains refused towards any host outside the local
  network.

### Fixed

- A personal home relay using a `ws://` or private-network address was
  accepted by the interface but silently discarded when saved, and again when
  reloaded, so the setting was lost on restart. Relay normalization existed in
  three divergent copies; there is now a single one used everywhere.

### Security

- Bounded the work a relay reply can impose. A relay answering a request with
  thousands of events carrying the account's public key and an invalid
  signature could block the interface for tens of seconds. Replies are now
  reduced before any signature verification, the amount verified per sync is
  capped, and verification yields regularly so the app stays responsive.
- Closed several ways to write an internal address that got past the
  loopback/private-network refusal on public relay entries, including
  IPv4-in-IPv6 forms and integer notations such as `2130706433` or `127.1`.
- Applied that same refusal to profile-avatar downloads, which follow
  redirects chosen by a remote host and previously had no such check.
- Rejected relay URLs containing control characters or out-of-range ports
  instead of storing a normalized version of them.
- Closed websocket connections to relays removed from the configuration
  instead of leaving them open until the app restarted.
- Restricted Android TLS trust to the system certificate store.

### Removed

- Unused `since` parameter on the task fetch and the never-read `about` field
  on cached profiles.
- The separate "public relay" and "home relay" URL rules, which had grown
  identical in everything except a flag every caller passed the same way.
  There is now one rule: encrypted transport everywhere, plaintext only
  towards the local network.

## [0.1.0] - 2026-07-19

First public release.

### Added

- Offline-first task management: titles, descriptions, due dates with time,
  comma-separated tags, 1–5 priorities, Echoes-style color coding, completed
  section.
- AES-256 encrypted local Hive database with the key in platform secure
  storage, including a verified one-time migration of the legacy plaintext
  database.
- Optional Nostr identity: import an existing nsec/hex key, generate a new
  account, or sign in with Amber (NIP-55) on Android.
- Encrypted multi-device sync over user-selected relays: NIP-44 self-encrypted
  kind `30789` parameterized-replaceable events, last-write-wins merge,
  encrypted deletion tombstones plus NIP-09 retraction.
- Hardened relay transport: `wss://`-only public relays with a
  loopback/private-address block, NIP-01 ID + Schnorr signature verification
  before decryption, bounded fetches, 12-endpoint fan-out cap, no automatic
  reconnect loops.
- Personal home relay as an additional backup target — the only slot allowed
  to use a plaintext `ws://` address, for LAN-only relays without TLS.
- Full localization in 27 languages (all EU official languages plus Japanese,
  Russian and Simplified Chinese), switchable at runtime from Settings.
- Settings: account management with protected nsec backup, relay management,
  theme (dark/light/system), language picker, Lightning donation tile.
- Three-page onboarding (intro, sign-in, relay choice) with an explicit
  offline/local-only path.
- Test suite: official NIP-44 v2 vectors, hostile-field validation, relay URL
  and settings coverage, settings/localization widget tests, onboarding
  coverage.

### Security

- See [docs/SECURITY_AUDIT.md](docs/SECURITY_AUDIT.md) for the full audit
  record of this release.

[Unreleased]: https://github.com/Lwb89dev/kairos/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/Lwb89dev/kairos/releases/tag/v1.0.0
[0.1.3]: https://github.com/Lwb89dev/kairos/releases/tag/v0.1.3
[0.1.2]: https://github.com/Lwb89dev/kairos/releases/tag/v0.1.2
[0.1.1]: https://github.com/Lwb89dev/kairos/releases/tag/v0.1.1
[0.1.0]: https://github.com/Lwb89dev/kairos/releases/tag/v0.1.0
