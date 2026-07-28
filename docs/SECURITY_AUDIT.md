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
- Added a scoped Astraea local bridge: Android uses an explicit package-bound
  intent, while Linux uses the per-user `XDG_RUNTIME_DIR` Unix socket. Both
  carry a versioned envelope and remain best-effort; no public TCP listener or
  shared task database is exposed.
- Replaced blanket `ws://` support with normalized, boundary-validated `wss://` only, keeping a single deliberate exception: the personal home-relay slot, which may use `ws://` and a private/loopback address for a LAN relay without TLS.
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
- Android release manifests now include Internet access and disable backup/device transfer. Cleartext remains permitted at the OS level because the optional `ws://` LAN home relay needs it (Android's network-security-config matches domains, not CIDR ranges, so "cleartext only towards RFC 1918" is not expressible); TLS trust anchors are restricted to the system CA store so a user-installed CA cannot intercept the `wss://` relay connections.
- Release builds cannot fall back to the debug signing identity.
- Android recents thumbnails are suppressed; private-key display uses `FLAG_SECURE`, sensitive clipboard metadata and timed clearing.
- Avatar downloads follow at most three manually validated HTTPS-only redirects, accept a raster MIME allowlist, use bounded decoding and enforce a 15-second per-request timeout plus a 5 MiB ceiling.
- Production application diagnostics are disabled and parser errors never include decrypted snippets.
- Rapid task updates receive strictly increasing whole-second Nostr timestamps.
- Onboarding completion is independent of login, preventing login from skipping relay consent.
- Task fields and relay responses are bounded to limit memory/resource exhaustion.
- Stale editors cannot resurrect deleted tasks or roll back concurrent completion/sync-ownership state.

## Second review — 28 July 2026

A follow-up review of the whole repository found the following, all corrected.

### Correctness

- The home relay was accepted by the UI and then silently discarded when
  persisted: relay sanitization had been copied into three places and two
  copies omitted the `allowInsecureLocal` flag, so a `ws://` or private-IP
  home relay — the entire purpose of the slot — was dropped on save and on
  reload, while the in-memory provider state still showed it as configured.
  There is now a single `SyncConfig.sanitized` used by every boundary.

### Denial of service

- A relay could freeze the UI isolate for tens of seconds by answering a REQ
  with thousands of events carrying the requested pubkey and a junk
  signature: each one bought a full Schnorr verification (~7 ms) on the main
  isolate, far past Android's 5 s ANR threshold. Replies are now reduced
  before any cryptography runs (kind 30789 is replaceable, so only the newest
  event per `d` tag is meaningful), the number of events reaching
  verification is capped, and verification yields to the event loop
  periodically so no uninterrupted batch approaches the ANR threshold. The
  same fix was applied to the kind-0 profile lookup.

### Attack surface

- The loopback/private-address refusal protecting the public relay list was
  bypassable by every non-canonical spelling of an internal address:
  IPv4-mapped and IPv4-compatible IPv6 (`::ffff:127.0.0.1`, `::127.0.0.1`),
  the NAT64 prefix, the unspecified addresses (`0.0.0.0`, `::`), and the
  `inet_aton` integer forms (`2130706433`, `0x7f000001`, `0177.0.0.1`,
  `127.1`). All are now canonicalized and refused.
- The avatar downloader had no private-address check at all, while being the
  only fetch in the app whose destination is chosen by a remote party (each
  redirect hop). A cooperating avatar host could bounce the request onto the
  user's LAN or a cloud metadata endpoint. It now shares the relay list's
  host predicate.
- URLs containing NUL bytes or other control characters were percent-encoded
  and stored rather than rejected; ports outside 0-65535 were accepted. Both
  are refused at the boundary now.
- Websockets to deselected relays stayed open for the rest of the session:
  `dart_nostr`'s `init()` accepts `ensureToClearRegistriesBeforeStarting` but
  never forwards it, so its registry is append-only. The relay set is now
  tracked and connections are torn down when it changes.
- Android TLS trust is restricted to the system CA store (see above).

### Dead code

- `NostrService.fetchTasks`'s `since` parameter was never passed by any
  caller; removed.
- `NostrProfile.about` was parsed and cached from relay data but never read;
  removed.

## Third pass — 28 July 2026

The follow-up implementation review found and corrected five additional
boundary/lifecycle defects:

- The final `NostrService` transport gate did not reuse the central relay URL
  policy. Direct callers could still hand it a private `wss://` host, an
  invalid port or a control-character URL. The transport now delegates to the
  same normalizer as persistence and settings.
- The `allowInsecureLocal` exception accepted `ws://` public hostnames, making
  the LAN-only exception a general cleartext escape hatch. Plaintext is now
  restricted to hosts that are locally identifiable; `wss://` remains valid
  for a public home relay.
- Local addresses with a DNS trailing dot (`localhost.` / `127.0.0.1.`) could
  bypass the textual private-address predicate. The predicate now canonicalizes
  trailing dots before checking DNS names and IP literal spellings.
- `dart_nostr` retains every received event in a process-wide registry and
  does not clear it when a relay disconnects. A process-wide guard and
  per-fetch cleanup now bound that cache to 64 events. Relay events also face
  structural limits before authentication/crypto, and the legacy storage
  migration was flattened into a guard-clause helper.
- The avatar downloader returned the response-body future while its `finally`
  closed the HTTP client, potentially cancelling the body before it was read.
  The body is now awaited before client cleanup.

Regression coverage was added for the URL bypasses, direct transport rejection
and event-cache cleanup. The suite now reports 161 passing tests.

## Residual risks

1. Nostr metadata remains visible: public key, IP, relay choices, kind, opaque task `d` identifier, timestamps, frequency and approximate size.
2. Kairos has no biometric/PIN app lock. Android recents protection prevents involuntary thumbnails but anyone with an unlocked device can open the app.
3. Secure storage and database encryption do not protect against a rooted device, malicious OS, runtime memory capture or an unlocked compromised process.
4. `dart_nostr`, Amber and native secure-storage plugins remain supply-chain dependencies; they require continued update/advisory review.
5. No integration tests currently exercise malicious live relays, MITM conditions, multiple disagreeing relays or a real Amber installation.
6. Linux packaging and keyring behavior require distribution-specific testing.
7. The private-address refusal inspects the URL text only. A DNS hostname
   that resolves to an internal address at connect time is still reached;
   DNS-rebinding protection would require resolving before connecting and is
   out of scope for a client where relay URLs are user-typed.
8. The per-fetch verification cap bounds how much work a hostile relay can
   impose, but an account legitimately holding more tasks than the cap would
   see the excess ignored on each sync.

This static/code-assisted audit is not a penetration test or formal
cryptographic proof. NIP-44 is checked against the canonical public vectors,
but the direct implementation should still receive independent review before a
high-risk deployment.

## Verification record

- `dart format`: clean.
- `flutter analyze`: no issues.
- `flutter test`: 161 tests passed, including official NIP-44 vectors.
- `flutter pub outdated`: 7 dependencies are locked below the newest
  mutually-resolvable versions; no major upgrade was forced during this audit.
- Sensitive filename/content scan: no credential material found in the workspace sources.
- Android debug build: still required on a machine where Flutter can update its SDK cache; this audit environment denied that out-of-workspace write before Gradle started.
- `dart format --output=none --set-exit-if-changed lib test`: clean when run
  with the SDK's direct Dart binary; the Flutter wrapper attempted an
  out-of-workspace SDK-cache update in this environment.
