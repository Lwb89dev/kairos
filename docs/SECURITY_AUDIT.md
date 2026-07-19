# Kairos security and privacy audit

Date: 19 July 2026

## Result

The review found and corrected high-impact issues in onboarding, Android
release configuration, Nostr trust boundaries, deletion semantics, relay
selection, avatar downloads and local storage. Static analysis, crypto vectors,
unit/widget tests and a debug Android build are the required release gate.

## Corrections applied

### High impact

- Replaced plaintext task persistence with AES-256 encrypted Hive storage and a verified legacy migration.
- Removed obsolete plaintext Unix-socket IPC that had no Astraea consumer and unnecessarily expanded the attack surface.
- Replaced `ws://` support with normalized, boundary-validated `wss://` only.
- Confined REQ streams to selected relays, waited for all EOSE responses, imposed timeout/event/byte limits and always closed listeners.
- Required NIP-01 ID and Schnorr-signature validation before accepting profile or task events.
- Required Amber's signed event to match author, kind, content, tags and timestamp requested.
- Required acknowledgement from every configured relay before marking a revision synchronized.
- Fixed deletion so NIP-09 retracts the preceding event rather than the newly published tombstone/coordinate.
- Added sync-owner binding so pending data cannot be uploaded to a different account after account switching.
- Disabled automatic reconnect loops in the Nostr dependency; foreground/manual sync reconnects explicitly.
- Disabled `dart_nostr`'s verbose logger, which is enabled by default and can include complete hostile relay frames and identity material.
- Capped configured relay fan-out at 12 endpoints at persistence, provider and transport boundaries.

### Privacy and reliability

- Fresh installs have no selected relay and profile lookup uses no hidden fallback endpoints.
- Android release manifests now include Internet access, disable backup/device transfer and reject cleartext traffic.
- Release builds cannot fall back to the debug signing identity.
- Android recents thumbnails are suppressed; private-key display uses `FLAG_SECURE`, sensitive clipboard metadata and timed clearing.
- Avatar downloads follow at most three manually validated HTTPS-only redirects, accept a raster MIME allowlist, use bounded decoding and enforce a 15-second per-request timeout plus a 5 MiB ceiling.
- Production application diagnostics are disabled and parser errors never include decrypted snippets.
- Rapid task updates receive strictly increasing whole-second Nostr timestamps.
- Onboarding completion is independent of login, preventing login from skipping relay consent.
- Task fields and relay responses are bounded to limit memory/resource exhaustion.
- Stale editors cannot resurrect deleted tasks or roll back concurrent completion/sync-ownership state.

## Residual risks

1. Nostr metadata remains visible: public key, IP, relay choices, kind, opaque task `d` identifier, timestamps, frequency and approximate size.
2. Kairos has no biometric/PIN app lock. Android recents protection prevents involuntary thumbnails but anyone with an unlocked device can open the app.
3. Secure storage and database encryption do not protect against a rooted device, malicious OS, runtime memory capture or an unlocked compromised process.
4. `dart_nostr`, Amber and native secure-storage plugins remain supply-chain dependencies; they require continued update/advisory review.
5. No integration tests currently exercise malicious live relays, MITM conditions, multiple disagreeing relays or a real Amber installation.
6. Linux packaging and keyring behavior require distribution-specific testing.

This static/code-assisted audit is not a penetration test or formal
cryptographic proof. NIP-44 is checked against the canonical public vectors,
but the direct implementation should still receive independent review before a
high-risk deployment.

## Verification record

- `dart format`: clean.
- `flutter analyze`: no issues.
- `flutter test`: 69 tests passed, including official NIP-44 vectors.
- `flutter pub outdated`: every direct dependency is at the newest mutually resolvable version; incompatible major versions were not forced.
- Sensitive filename/content scan: no credential material found in the workspace sources.
- Android debug build: still required on a machine where Flutter can update its SDK cache; this audit environment denied that out-of-workspace write before Gradle started.
