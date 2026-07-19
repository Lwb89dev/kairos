# Security policy

Task data and Nostr identities are sensitive. Do not disclose a suspected
vulnerability through a public issue, discussion or pull request.

## Supported versions

| Version | Support |
| --- | --- |
| Latest release | Supported |
| Older releases | Best effort |
| Unreleased development builds | No guarantee |

## Reporting a vulnerability

Use GitHub's private **Report a vulnerability** security-advisory flow for this
repository. Include the affected version/platform, impact, minimal reproduction
steps and whether a private key or decrypted task content may be exposed. Use
generated identities and synthetic tasks; never attach a real nsec or personal
database.

Maintainers should acknowledge reports within seven days, coordinate a
reasonable remediation window and agree on disclosure timing.

## Security boundaries

Kairos encrypts local task records and Nostr event content. Nostr metadata is
not confidential, and a rooted, malicious or already-compromised operating
system is outside the threat model. This code-assisted review does not replace
an independent penetration test, supply-chain audit or formal cryptographic
review. See [docs/SECURITY_AUDIT.md](docs/SECURITY_AUDIT.md).
