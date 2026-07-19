# Kairos

[![CI](https://img.shields.io/badge/CI-flutter%20analyze%20%2B%20test-blue)](.github/workflows/ci.yml)
[![License: GPL-3.0-or-later](https://img.shields.io/badge/License-GPL--3.0--or--later-green.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-stable-02569B?logo=flutter)](https://flutter.dev)
[![Nostr](https://img.shields.io/badge/Sync-Nostr%20%2B%20NIP--44-purple)](https://github.com/nostr-protocol/nips)

Kairos is a focused, offline-first task manager in the Echoes ecosystem. Tasks
are saved locally before any network operation and the application remains
fully usable without an account or internet connection. Optional multi-device
sync uses user-selected Nostr relays; task content is NIP-44 encrypted before it
leaves the device — relays only ever see ciphertext.

## Features

- **Offline-first**: task creation, editing, completion, priorities, tags, colors and due dates — no account or connection required.
- **Encrypted at rest**: AES-256 encrypted local Hive database; the key is held by platform secure storage.
- **Encrypted in transit**: NIP-44 encrypted kind `30789` parameterized-replaceable events. No cleartext titles, dates, statuses or tags ever reach a relay.
- **Your identity, your relays**: Nostr identity via imported/generated key or [Amber](https://github.com/greenart7c3/Amber) (NIP-55) on Android. Fresh installs contact no relay by default.
- **Personal home relay**: an optional additional backup target for people running their own relay. It is the *only* slot allowed to use a plaintext `ws://` address (for LAN-only relays without TLS); every other relay must be `wss://` and may not point at loopback/private addresses.
- **27 languages**: full localization (all EU official languages plus Japanese, Russian and Chinese), switchable at runtime from Settings.
- **Hardened transport**: authenticated relay input (NIP-01 event ID and Schnorr signature verified before decryption), bounded fetches, capped relay fan-out (12 endpoints), no automatic reconnect loops.
- **Safe deletion**: encrypted tombstone plus a NIP-09 request for the preceding revision.
- **Light, dark and system themes** — dark by default.
- **No ads, no analytics, no telemetry, no Kairos-operated server.**

## Screenshots

<!-- Add screenshots here, e.g.:
<p float="left">
  <img src="docs/screenshots/tasks.png" width="24%" />
  <img src="docs/screenshots/editor.png" width="24%" />
  <img src="docs/screenshots/settings.png" width="24%" />
  <img src="docs/screenshots/onboarding.png" width="24%" />
</p>
-->

## How synchronization works

1. Every mutation is committed to the encrypted local database first.
2. With a Nostr account and at least one selected relay, Kairos NIP-44 encrypts the complete task JSON to the user's own identity.
3. Kairos signs and publishes a kind `30789` event under a stable `d` tag.
4. Every configured relay, including the personal home relay, must acknowledge the event before the revision is marked synchronized.
5. Pulls are limited by time, event size/count and aggregate bytes; valid events are merged last-write-wins by `updatedAt`.
6. Amber sessions synchronize only after an explicit user gesture, avoiding surprise signer prompts.

The stable wire prefix remains `checkmarks:` so tasks published by pre-rename
versions are not orphaned. The Android `applicationId` likewise remains
`dev.echoes.checkmarks` to preserve the upgrade path and local data; the app
label, Dart package, native namespace, Linux ID and visible branding are Kairos.

## Localization

Kairos ships in 27 languages: Bulgarian, Croatian, Czech, Danish, Dutch,
English, Estonian, Finnish, French, German, Greek, Hungarian, Irish, Italian,
Japanese, Latvian, Lithuanian, Maltese, Polish, Portuguese, Romanian, Russian,
Simplified Chinese, Slovak, Slovenian, Spanish and Swedish.

The language follows the system locale by default and can be overridden from
Settings. Translation source lives in `lib/l10n/app_<locale>.arb`
(`app_en.arb` is the template); the Dart bindings are generated with
`flutter gen-l10n`. Translation fixes are welcome — edit the ARB file for your
language and open a pull request.

## Privacy and security boundaries

NIP-44 hides task contents, not all Nostr metadata. A relay can still observe
the public key, IP address, event kind, opaque task `d` identifier, timestamps,
update frequency and approximate payload sizes. Android backup and cleartext
traffic are disabled (with the sole, deliberate exception of a user-configured
`ws://` home relay), but a rooted or already-compromised device is outside the
threat model.

Read [PRIVACY.md](PRIVACY.md), [SECURITY.md](SECURITY.md) and the latest
[security audit](docs/SECURITY_AUDIT.md) before handling sensitive data.

## Platform status

| Platform | Status | Notes |
| --- | --- | --- |
| Android | Supported | Primary hardened target; Amber and protected key backup available. |
| Linux | Supported | Local-key sessions; desktop packaging is not included. |
| iOS, web, Windows, macOS | Not configured | No platform project is present in this repository. |

## Getting started

### Requirements

- Flutter stable with Dart 3.12.2 or newer
- JDK 17 and Android SDK 36 for Android builds
- A configured Android device/emulator, or Linux Flutter desktop prerequisites (`cmake`, `clang`, `ninja-build`, GTK 3 headers)

### Build and run

```bash
flutter pub get --enforce-lockfile
flutter run                    # pick a connected device
flutter build apk --debug      # Android
```

### Verify

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
bash tool/check_repository_hygiene.sh
```

The test suite includes official NIP-44 v2 vectors, hostile-field validation,
relay URL/settings coverage, settings/localization widget tests and onboarding
coverage.

## Release signing

Release builds intentionally fail unless a dedicated keystore is configured.
Copy `android/key.properties.example` to `android/key.properties`, point it to a
keystore outside the repository and replace every placeholder. Never commit the
resulting properties file, keystore or passwords.

## Project layout

```text
lib/l10n/         ARB translation sources (27 locales) and generated bindings
lib/models/       Task, identity, profile and sync configuration
lib/providers/    Riverpod state and application orchestration
lib/screens/      Task list/editor/details, onboarding and settings
lib/services/     Encrypted storage, Nostr transport and sync
lib/utils/        NIP-44, validation, formatting and colors
android/          Hardened Android host and launcher resources
linux/            Linux desktop runner
test/             Unit, widget and official crypto-vector tests
docs/             Architecture and security audit
```

## Contributing

Contributions are welcome — see [CONTRIBUTING.md](CONTRIBUTING.md) and the
[code of conduct](CODE_OF_CONDUCT.md). Security vulnerabilities must be
reported privately as described in [SECURITY.md](SECURITY.md), never through a
public issue containing real data.

## Support

If Kairos is useful to you, you can support development with a Lightning
donation from **Settings → Support**, or directly to `lwb89@blink.sv`. ⚡

## License

Kairos is free software, licensed under the
[GNU General Public License v3.0 or later](LICENSE).
