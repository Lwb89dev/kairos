/// Produces a timestamp strictly newer than [previous] at Nostr's whole-second
/// resolution. Without this, two rapid edits of a replaceable event can share
/// `created_at` and a relay may retain an arbitrary older revision.
DateTime nextNostrTimestamp(DateTime previous) {
  final now = DateTime.now().toUtc();
  final currentSecond = DateTime.fromMillisecondsSinceEpoch(
    (now.millisecondsSinceEpoch ~/ 1000) * 1000,
    isUtc: true,
  );
  final previousSecond = DateTime.fromMillisecondsSinceEpoch(
    (previous.toUtc().millisecondsSinceEpoch ~/ 1000) * 1000,
    isUtc: true,
  );
  final next = previousSecond.add(const Duration(seconds: 1));
  return currentSecond.isAfter(next) ? currentSecond : next;
}
