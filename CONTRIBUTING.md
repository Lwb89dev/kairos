# Contributing to Kairos

Thank you for helping improve Kairos. Contributions should preserve its core
properties: offline-first behavior, explicit network use, authenticated
encryption and safe handling of task data.

## Before opening an issue

- Search existing issues first.
- Use the bug template for reproducible defects.
- Use the feature template for product proposals and describe the privacy
  impact of any new network, storage or permission requirement.
- Report vulnerabilities privately as described in [SECURITY.md](SECURITY.md).

## Development setup

Install Flutter stable, JDK 17 and the Android toolchain (or the Linux desktop
prerequisites), then run:

```bash
flutter pub get --enforce-lockfile
flutter analyze
flutter test
flutter run
```

Do not add real keys, task exports, signing files, service credentials or
machine-specific configuration to the repository.

## Translations

Translation sources live in `lib/l10n/app_<locale>.arb`; `app_en.arb` is the
template and defines the key set. To fix or improve a translation:

1. Edit the value in the relevant `app_<locale>.arb` file. Never change key
   names, ICU placeholders (`{count}`, `{address}`, …) or the `@key` metadata
   blocks.
2. Run `flutter gen-l10n` to regenerate the Dart bindings.
3. Run `flutter test` — placeholder or key mismatches fail generation.

## Pull requests

Keep changes focused and explain both the user-visible behavior and the design
trade-offs. A pull request should:

- format changed Dart files with `dart format`;
- pass `bash tool/check_repository_hygiene.sh`;
- pass `flutter analyze` and `flutter test`;
- add or update tests for changed behavior;
- preserve local writes before network operations;
- validate all relay and file input at the trust boundary — in particular,
  keep the `wss://`-only rule for public relays (the `ws://` exception is
  reserved for the personal home relay slot);
- avoid logging private keys, decrypted task data or task contents;
- update README, privacy or changelog documentation when needed.

Major dependency upgrades should be isolated from feature work and include an
Android build. Cryptographic changes require official vectors or independently
verifiable fixtures.

## Style

- Follow `analysis_options.yaml`.
- Write all source comments and identifiers in English.
- Prefer small, composable widgets and services with explicit responsibilities.
- Keep protocol and security rationale near the code that enforces it.
- Use UTC for persisted instants and convert only at display edges.
- All user-visible strings go through `AppLocalizations` — no hardcoded UI
  text.

## Commit hygiene

Use clear imperative subjects, for example `Fix due-date rollover at midnight`.
Do not include generated editor metadata, local paths, private work logs or
secret material in commits. Review `git diff --staged` before every push.

By contributing, you agree that your work is licensed under GPL-3.0-or-later.
