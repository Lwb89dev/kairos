# Kairos

[![CI](https://img.shields.io/badge/CI-flutter%20analyze%20%2B%20test-blue)](.github/workflows/ci.yml)
[![License: GPL-3.0-or-later](https://img.shields.io/badge/License-GPL--3.0--or--later-green.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-stable-02569B?logo=flutter)](https://flutter.dev)
[![Nostr](https://img.shields.io/badge/Sync-Nostr%20%2B%20NIP--44-purple)](https://github.com/nostr-protocol/nips)

**Offline-first, end-to-end encrypted tasks — synced privately over
[Nostr](https://nostr.com), on your terms.**

Kairos is a task manager that treats the network as optional. Every task is
written to an encrypted local database before anything touches the network, and
the app is fully usable with no account and no connection at all. When you do
sign in and pick relays, the entire task — title, notes, due date, tags,
priority — is NIP-44 encrypted to your own key before it leaves the device.
Relay operators only ever see ciphertext and an opaque identifier.

It is the task app of the **Echoes ecosystem**: one Nostr identity across
notes, calendar and tasks, with no server of ours anywhere in the picture. A
task you schedule for a future day can show up in the
[Astraea](https://github.com/Lwb89dev/astraea) calendar and its home-screen
widget — see [Ecosystem](#ecosystem).

## Features

- **Offline-first**: task creation, editing, completion, priorities, tags, colors and due dates — no account or connection required.
- **Encrypted at rest**: AES-256 encrypted local Hive database; the key is held by platform secure storage.
- **Encrypted in transit**: NIP-44 encrypted kind `30789` parameterized-replaceable events. No cleartext titles, dates, statuses or tags ever reach a relay.
- **Your identity, your relays**: Nostr identity via imported/generated key or [Amber](https://github.com/greenart7c3/Amber) (NIP-55) on Android. Fresh installs contact no relay by default.
- **Reminders**: a task with a due date can carry several notifications, from "at the due time" up to a day ahead. They are scheduled with the operating system when the task is saved — nothing polls, nothing runs in the background — and they travel with the task to the account's other devices.
- **Astraea calendar**: a dated task can be published as an event in [Astraea](https://github.com/Lwb89dev/astraea), the sibling calendar app, so it shows up there in the calendar and the home-screen widget. Opt-in per task. Kairos also sends an explicit same-device instruction on Android/Linux; Nostr remains the durable cross-device path.
- **Self-hosted relays**: relays on your own network can be added to the ordinary relay list as well as to the dedicated home-relay slot. Plaintext `ws://` is accepted only towards a private, loopback or `.local` address — where the traffic never leaves your network — and always refused towards a public host.
- **27 languages**: full localization (all EU official languages plus Japanese, Russian and Chinese), switchable at runtime from Settings.
- **Hardened transport**: authenticated relay input (NIP-01 event ID and Schnorr signature verified before decryption), bounded fetches, capped relay fan-out (12 endpoints), no automatic reconnect loops.
- **Safe deletion**: encrypted tombstone plus a NIP-09 request for the preceding revision.
- **Light, dark and system themes** — dark by default.
- **No ads, no analytics, no telemetry, no Kairos-operated server.**

Everything above works with no account at all. Signing in only adds
synchronization.

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

## Ecosystem

Kairos, [Echoes](https://github.com/Lwb89dev/echoes) and
[Astraea](https://github.com/Lwb89dev/astraea) are three apps built on the same
foundation: your notes, your calendar and your tasks, each offline-first, each
NIP-44 encrypted to your own key, none of them talking to a server we operate.

| App | What it holds | Nostr kind | `d` tag namespace |
| --- | --- | --- | --- |
| [Echoes](https://github.com/Lwb89dev/echoes) | Notes, checklists, voice memos, images | `30078` | its own |
| [Astraea](https://github.com/Lwb89dev/astraea) | Calendar events | `30078` | `epochs:` |
| **Kairos** | Tasks | `30789` | `checkmarks:` |

### One identity, three apps

All three sign in with the same Nostr key — imported, generated, or held
outside every app by [Amber](https://github.com/greenart7c3/Amber) (NIP-55).
With Amber you authenticate once for the whole ecosystem and no app ever sees
the private key. Point them at the same relays and your notes, calendar and
tasks all sync through infrastructure you chose, independently of one another:
each app reads only its own namespace, so they can share a key and a relay set
without ever seeing each other's data.

### Tasks in the Astraea calendar

A task with a due date can be published as an Astraea calendar event, so a
deadline you set in Kairos also appears in Astraea's calendar and its
home-screen widget on the day it falls. Enable it per task from the editor.

When both apps are installed on Android, Kairos also sends Astraea a local,
versioned upsert instruction immediately, including an explicit notification
request. **The relays remain the durable integration point**:
Kairos writes an event in exactly the shape Astraea already reads
(kind `30078`, `d` tag `epochs:<task-id>`, NIP-44 encrypted with the account
key it also holds), and Astraea's next sync picks it up like any other event.
Its widgets are drawn from its own local store, so they update on their own.
The local receiver contract is documented in
[`docs/ASTRAEA_LOCAL_PROTOCOL.md`](docs/ASTRAEA_LOCAL_PROTOCOL.md); if Astraea
is unavailable, the task and its Nostr mirror are unaffected.

The mirror is deliberately one-way and opt-in per task:

- A **local-only** task is never mirrored — the whole point of pinning it to
  the device is that it does not reach a relay.
- The calendar coordinate is derived from the task id, so editing a task
  replaces its own calendar entry instead of piling up duplicates.
- Kairos never *reads* your calendar. A mirror that cannot read cannot corrupt
  it. The trade-off: editing the mirrored event inside Astraea is overwritten
  next time the task changes in Kairos — the task owns its own mirror.
- Removing the task, or unticking the option, retracts the calendar event.

### Shared design

The apps share more than a key: the same Riverpod state layout, the same
audited relay and identity handling, the same in-house NIP-44 implementation
verified against the official specification vectors, and the same rule that
nothing is published without an explicit choice. A fix in one is a fix worth
carrying to the others.

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
update frequency and approximate payload sizes. Android backup and device transfer are
disabled, and TLS trust is restricted to the system CA store so a
user-installed certificate authority cannot intercept relay connections.
Cleartext stays permitted at the OS level only because the optional
user-configured `ws://` LAN home relay needs it. A rooted or
already-compromised device is outside the threat model.

Read [PRIVACY.md](PRIVACY.md), [SECURITY.md](SECURITY.md) and the latest
[security audit](docs/SECURITY_AUDIT.md) before handling sensitive data.

## Platform status

| Platform | Status | Notes |
| --- | --- | --- |
| Android | Supported | Primary hardened target; Amber and protected key backup available. |
| Linux | Supported | Local-key sessions; desktop packaging is not included. |
| iOS, web, Windows, macOS | Not configured | No platform project is present in this repository. |

## Install

Signed APKs are attached to each [release](https://github.com/Lwb89dev/kairos/releases),
split per ABI — pick the one matching your device rather than the fat APK:

| File | For |
| --- | --- |
| `app-arm64-v8a-release.apk` | Almost every phone from ~2017 onward (64-bit ARM) |
| `app-armeabi-v7a-release.apk` | Older 32-bit ARM devices |
| `app-x86_64-release.apk` | Emulators and x86 tablets/Chromebooks |

Verify the download before installing it — the certificate fingerprint must
match the one published with the release:

```bash
apksigner verify --print-certs app-arm64-v8a-release.apk
```

Android will warn that the app comes from an unknown source; that is expected
for a self-signed build installed outside a store.

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

Release APKs, split per ABI (requires a configured keystore — see
[Release signing](#release-signing)):

```bash
flutter build apk --release --split-per-abi
# build/app/outputs/flutter-apk/app-<abi>-release.apk
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

Release builds intentionally **fail** unless a dedicated keystore is
configured, so a distributable build can never go out carrying the debug
identity:

```bash
keytool -genkeypair -v \
  -keystore ~/.android-keystores/kairos-release.jks \
  -alias kairos -keyalg RSA -keysize 4096 -validity 10000 \
  -storetype PKCS12 -dname "CN=Kairos, O=YourName, C=XX"

cp android/key.properties.example android/key.properties
# then point storeFile at the keystore and fill in the passwords
```

`android/key.properties`, `*.jks` and `*.keystore` are all gitignored, and
`tool/check_repository_hygiene.sh` fails the build if one is ever staged.

> [!WARNING]
> Back up the keystore and its password somewhere durable. Android identifies
> an app by its signing certificate: lose the key and you can never ship an
> update that existing installs will accept — users would have to uninstall and
> lose local data.

## Project layout

```text
lib/l10n/         ARB translation sources (27 locales) and generated bindings
lib/models/       Task, identity, profile and sync configuration
lib/providers/    Riverpod state and application orchestration
lib/screens/      Task list/editor/details, onboarding and settings
lib/services/     Encrypted storage, Nostr transport, sync, reminders,
                  Astraea calendar mirror
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
