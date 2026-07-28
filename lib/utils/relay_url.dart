import 'dart:io';
import 'dart:typed_data';

/// Hard ceiling on any URL this app is willing to parse, store or dial.
const int kMaxUrlLength = 2048;

/// Returns a normalized Nostr relay URL, or `null` when [input] is malformed
/// or would send cleartext off the user's own network.
///
/// One rule, applied identically to every relay slot — the public list, the
/// suggested relays and the personal home relay:
///
///  - `wss://` is accepted anywhere, including towards a private or loopback
///    address, so a self-hosted relay that *does* terminate TLS works in any
///    slot.
///  - `ws://` is accepted only towards a private, loopback or `.local` host.
///    That is what a LAN relay on a Raspberry Pi or NAS looks like, and it is
///    the only situation where plaintext is defensible: the traffic never
///    leaves the user's network, and the payload is NIP-44 encrypted anyway.
///    Plaintext to a public host stays refused — it would leak connection
///    metadata to anyone on the path and turn the LAN exception into a
///    general cleartext escape hatch.
///
/// The scheme and the host are therefore validated *together*: neither alone
/// decides. There is deliberately no flag to relax this per call site — a
/// boolean that every caller passes as `true` is not a policy, and the
/// property worth protecting (cleartext never leaves the LAN) has to hold at
/// every entry point or it holds at none.
///
/// Also strips a trailing `/` from the path so cosmetically different URLs
/// for the same relay (`wss://relay.io` vs `wss://relay.io/`) normalize to
/// the same string and dedupe correctly wherever relay lists use `Set`/
/// `.toSet()` equality.
String? normalizeSecureRelayUrl(String input) {
  final raw = input.trim();
  if (raw.length > kMaxUrlLength || _hasControlCharacters(raw)) return null;

  final uri = Uri.tryParse(raw);
  if (uri == null || !_hasSaneAuthority(uri)) return null;

  final scheme = uri.scheme.toLowerCase();
  if (scheme != 'wss' && scheme != 'ws') return null;
  if (scheme == 'ws' && !isPrivateOrLoopbackHost(uri.host)) return null;

  var path = uri.path;
  while (path.endsWith('/')) {
    path = path.substring(0, path.length - 1);
  }

  return uri
      .replace(scheme: scheme, host: uri.host.toLowerCase(), path: path)
      .toString();
}

/// Shared authority sanity check for every outbound URL the app dials,
/// whatever the scheme: a resolvable host, no embedded credentials, no
/// fragment, and a port inside the range a TCP stack can actually use.
///
/// `Uri` happily parses `wss://host:99999` and `wss://host:-1`; the failure
/// only surfaces much later at connect time, so reject them at the boundary
/// instead of persisting a URL that can never work.
bool _hasSaneAuthority(Uri uri) {
  if (uri.host.isEmpty || uri.userInfo.isNotEmpty || uri.hasFragment) {
    return false;
  }
  return uri.port >= 0 && uri.port <= 65535;
}

/// Rejects NUL bytes and any other C0/C1 control character. `Uri` silently
/// percent-encodes them (`wss://relay.example%00`), which would let a
/// visually-identical-looking but different URL be stored and dialed.
bool _hasControlCharacters(String value) {
  return value.codeUnits.any((c) => c < 0x20 || (c >= 0x7f && c <= 0x9f));
}

/// True when [host] denotes a loopback, unspecified, private (RFC 1918/4193)
/// or link-local (incl. cloud metadata endpoints like `169.254.169.254`)
/// address, or the `localhost`/`.local` hostname convention.
///
/// This is deliberately stricter than "parse it as an IP and look at the
/// bytes", because there are many spellings of the same internal address and
/// the OS resolver accepts nearly all of them:
///
///  - IPv4-mapped/compatible/NAT64 IPv6 forms (`::ffff:127.0.0.1`,
///    `::127.0.0.1`, `64:ff9b::7f00:1`) all reach the embedded IPv4 address,
///    but `InternetAddress.isLoopback` only recognizes the literal `::1`.
///  - `inet_aton`-style IPv4 literals (`2130706433`, `0x7f000001`,
///    `0177.0.0.1`, `127.1`) are all 127.0.0.1 to `getaddrinfo`, yet
///    `InternetAddress.tryParse` returns null for every one of them, so a
///    naive implementation files them under "ordinary DNS hostname".
///
/// Plain DNS hostnames that merely *resolve* to such an address at connect
/// time are still not caught here (this is a client app where relay URLs are
/// user-typed, so DNS-rebinding protection is out of scope) — this blocks
/// every address that is unambiguously local right in the URL text.
bool isPrivateOrLoopbackHost(String host) {
  final normalized = host.toLowerCase().replaceFirst(RegExp(r'\.+$'), '');
  if (normalized == 'localhost' ||
      normalized.endsWith('.localhost') ||
      normalized.endsWith('.local')) {
    return true;
  }

  final address =
      InternetAddress.tryParse(normalized) ??
      _parseLegacyIpv4Literal(normalized);
  if (address == null) return false; // A regular DNS hostname.
  if (address.isLoopback) return true;

  final bytes = address.rawAddress;
  return address.type == InternetAddressType.IPv4
      ? _isPrivateIpv4(bytes)
      : _isPrivateIpv6(bytes);
}

bool _isPrivateIpv4(Uint8List b) {
  if (b[0] == 0) return true; // 0.0.0.0/8 ("this host"), incl. 0.0.0.0
  if (b[0] == 10) return true; // 10.0.0.0/8
  if (b[0] == 127) return true; // 127.0.0.0/8
  if (b[0] == 100 && b[1] >= 64 && b[1] <= 127) return true; // 100.64/10 CGNAT
  if (b[0] == 172 && b[1] >= 16 && b[1] <= 31) return true; // 172.16.0.0/12
  if (b[0] == 169 && b[1] == 254) return true; // 169.254.0.0/16
  if (b[0] == 192 && b[1] == 168) return true; // 192.168.0.0/16
  return false;
}

bool _isPrivateIpv6(Uint8List b) {
  if ((b[0] & 0xfe) == 0xfc) return true; // fc00::/7 (unique local)
  if (b[0] == 0xfe && (b[1] & 0xc0) == 0x80) return true; // fe80::/10

  // Covers `::` (unspecified) too: it decodes to the embedded 0.0.0.0, which
  // `_isPrivateIpv4` already treats as local.
  final embedded = _embeddedIpv4(b);
  return embedded != null && _isPrivateIpv4(embedded);
}

/// Extracts the IPv4 address carried inside an IPv6 one, for the three
/// encodings that actually reach an IPv4 destination: IPv4-mapped
/// (`::ffff:0:0/96`), IPv4-compatible (`::/96`, deprecated but still
/// routed by some stacks) and the NAT64 well-known prefix (`64:ff9b::/96`).
Uint8List? _embeddedIpv4(Uint8List b) {
  final tail = Uint8List.fromList(b.sublist(12));
  final leadingZeros = b.take(10).every((byte) => byte == 0);

  if (leadingZeros && b[10] == 0xff && b[11] == 0xff) return tail; // ::ffff:
  if (b[0] == 0x00 && b[1] == 0x64 && b[2] == 0xff && b[3] == 0x9b) {
    return tail; // 64:ff9b::/96
  }
  // ::a.b.c.d — but not `::` itself or `::1`, handled by the callers.
  if (leadingZeros && b[10] == 0 && b[11] == 0) return tail;
  return null;
}

/// Parses the `inet_aton` IPv4 spellings `getaddrinfo` accepts but
/// `InternetAddress.tryParse` rejects: 1-4 dot-separated parts, each decimal,
/// octal (`0` prefix) or hexadecimal (`0x` prefix), with the final part
/// absorbing all remaining low-order bytes (`127.1` == `127.0.0.1`).
/// Returns null for anything that is not one of those forms — an ordinary
/// DNS hostname must fall through untouched.
InternetAddress? _parseLegacyIpv4Literal(String host) {
  final parts = host.split('.');
  if (parts.isEmpty || parts.length > 4) return null;

  final values = <int>[];
  for (final part in parts) {
    final value = _parseIpv4Part(part);
    if (value == null) return null;
    values.add(value);
  }

  // Every part but the last must fit in one byte; the last absorbs the rest.
  if (values.take(values.length - 1).any((v) => v > 0xff)) return null;
  final remainingBytes = 4 - values.length;
  if (values.last > (1 << (8 * (remainingBytes + 1))) - 1) return null;

  var packed = 0;
  for (var i = 0; i < values.length - 1; i++) {
    packed |= values[i] << (8 * (3 - i));
  }
  packed |= values.last;

  return InternetAddress.fromRawAddress(
    Uint8List.fromList([
      (packed >> 24) & 0xff,
      (packed >> 16) & 0xff,
      (packed >> 8) & 0xff,
      packed & 0xff,
    ]),
  );
}

int? _parseIpv4Part(String part) {
  if (part.isEmpty || part.length > 11) return null;
  final lower = part.toLowerCase();
  if (lower.startsWith('0x')) return _parseRadix(lower.substring(2), 16);
  if (lower.length > 1 && lower.startsWith('0')) {
    return _parseRadix(lower.substring(1), 8);
  }
  return _parseRadix(lower, 10);
}

int? _parseRadix(String digits, int radix) {
  if (digits.isEmpty) return null;
  final value = int.tryParse(digits, radix: radix);
  return (value == null || value < 0 || value > 0xffffffff) ? null : value;
}
