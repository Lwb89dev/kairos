import 'dart:io';

/// Returns a normalized Nostr relay URL, or `null` when [input] is
/// malformed, uses an unencrypted websocket connection, or (for the public
/// relay list) points at a loopback/private/link-local address.
///
/// Set [allowInsecureLocal] only for the personal home-relay slot (see
/// `HomeRelayTile`): it may then also use a plaintext `ws://` address and
/// point at a private/loopback host, since that's exactly what a relay
/// running on the user's own network is. Every other relay entry point
/// (the public relay list, suggested relays) keeps the default `wss://`-only,
/// no-private-IP behavior — a public relay slot has no legitimate reason to
/// dial internal infrastructure.
///
/// Also strips a trailing `/` from the path so cosmetically different URLs
/// for the same relay (`wss://relay.io` vs `wss://relay.io/`) normalize to
/// the same string and dedupe correctly wherever relay lists use `Set`/
/// `.toSet()` equality.
String? normalizeSecureRelayUrl(
  String input, {
  bool allowInsecureLocal = false,
}) {
  final raw = input.trim();
  if (raw.length > 2048) return null;
  final uri = Uri.tryParse(raw);
  if (uri == null ||
      uri.host.isEmpty ||
      uri.userInfo.isNotEmpty ||
      uri.hasFragment) {
    return null;
  }

  final scheme = uri.scheme.toLowerCase();
  final schemeAllowed = allowInsecureLocal
      ? (scheme == 'wss' || scheme == 'ws')
      : scheme == 'wss';
  if (!schemeAllowed) return null;

  if (!allowInsecureLocal && _isPrivateOrLoopbackHost(uri.host)) return null;

  var path = uri.path;
  while (path.endsWith('/')) {
    path = path.substring(0, path.length - 1);
  }

  return uri
      .replace(scheme: scheme, host: uri.host.toLowerCase(), path: path)
      .toString();
}

/// True when [host] is a loopback, private (RFC 1918/4193), or link-local
/// (incl. cloud metadata endpoints like `169.254.169.254`) address, or the
/// `localhost`/`.local` hostname convention. Plain DNS hostnames that merely
/// *resolve* to such an address at connect time are not caught here (this is
/// a client app where relay URLs are always user-typed, not attacker
/// supplied, so DNS-rebinding protection is out of scope) — this only
/// blocks addresses that are unambiguously local right in the URL text.
bool _isPrivateOrLoopbackHost(String host) {
  final normalized = host.toLowerCase();
  if (normalized == 'localhost' ||
      normalized.endsWith('.localhost') ||
      normalized.endsWith('.local')) {
    return true;
  }

  final address = InternetAddress.tryParse(host);
  if (address == null) {
    return false; // A regular DNS hostname, not an IP literal.
  }
  if (address.isLoopback) return true;

  final bytes = address.rawAddress;
  if (address.type == InternetAddressType.IPv4) {
    if (bytes[0] == 10) return true; // 10.0.0.0/8
    if (bytes[0] == 172 && bytes[1] >= 16 && bytes[1] <= 31) {
      return true; // 172.16.0.0/12
    }
    if (bytes[0] == 192 && bytes[1] == 168) return true; // 192.168.0.0/16
    if (bytes[0] == 169 && bytes[1] == 254) return true; // 169.254.0.0/16
    return false;
  }
  if (address.type == InternetAddressType.IPv6) {
    if ((bytes[0] & 0xfe) == 0xfc) return true; // fc00::/7 (unique local)
    if (bytes[0] == 0xfe && (bytes[1] & 0xc0) == 0x80) return true; // fe80::/10
    return false;
  }
  return false;
}
