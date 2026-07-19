# Kairos privacy policy

Last updated: 19 July 2026

Kairos works without a central service. This document describes what it stores
and when it communicates with third parties.

## Data stored on the device

Kairos stores tasks, completion state, descriptions, due dates, tags, colors,
priorities, relay configuration and preferences locally. Task records are held
in an AES-256 encrypted Hive database. Its key and any locally held Nostr
private key are stored through the platform secure-storage facility. With
Amber, the Nostr private key remains in the external signer.

Android cloud backup and device transfer are disabled for all application data.
Removing the app deletes app-private local data according to the operating
system's uninstall behavior.

## Network activity

Fresh installations select no relay and Kairos can remain entirely local. With
a Nostr account and user-selected relays, Kairos publishes NIP-44 encrypted task
content and retrieves encrypted revisions. It does not silently add metadata
relays: public profile lookup uses only the selected relays. A profile avatar
may be downloaded over HTTPS from the URL in the user's authenticated public
profile, with a raster MIME allowlist, HTTPS-only redirect, timeout and
five-megabyte limits.

NIP-44 protects content, not transport metadata. Relay operators can observe
the public key, source IP, event kind, opaque per-task `d` identifier,
timestamps, update frequency and payload sizes. Relays and avatar hosts are
independent third parties with their own retention and privacy practices.

## Analytics and advertising

Kairos contains no advertising, analytics SDK, behavioral tracking or
developer-operated telemetry backend. Release builds suppress application
diagnostic logs.

## Data deletion

Deleting a synchronized task creates an encrypted tombstone and a NIP-09
request for its preceding concrete event. Independent relays may ignore a
deletion request or retain data under their own policies.

## Changes

Material privacy changes should be documented in the repository and reflected
in the date above.
