# Changelog

All notable changes to Kairos are documented in this file. The format is based
on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project
adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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

[Unreleased]: https://github.com/OWNER/REPO/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/OWNER/REPO/releases/tag/v0.1.0
