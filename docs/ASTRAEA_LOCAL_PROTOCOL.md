# Kairos → Astraea local protocol

Nostr remains the durable sync channel between the two apps. On Android, Kairos
also sends a same-device command to Astraea immediately after a task mutation.
The command is delivered through an explicit intent, so task contents are not
offered to arbitrary applications.

## Android registration

Astraea must expose an exported activity (or an exported receiver that forwards
to its importer) with this intent filter:

```xml
<intent-filter>
    <action android:name="dev.echoes.astraea.action.LOCAL_SYNC" />
    <category android:name="android.intent.category.DEFAULT" />
</intent-filter>
```

Kairos tries Astraea's current development package `com.example.epochs`, the
owned package `dev.echoes.astraea`, and the historical `dev.echoes.epochs`
package for users who have not upgraded Astraea's Android application id. The
JSON is in the string extra
`dev.echoes.astraea.extra.PAYLOAD` and has MIME type `application/json`.

## Message shape

Every message has this envelope:

```json
{
  "protocol": "dev.echoes.astraea.local",
  "version": 1,
  "source": "kairos",
  "operation": "upsert",
  "taskId": "task-uuid",
  "event": { "...": "Astraea Event.fromJson fields" },
  "notification": {
    "show": true,
    "source": "Kairos",
    "title": "Task from Kairos",
    "body": "Pay the electricity bill",
    "dedupeKey": "kairos:task-uuid:1785574800000"
  }
}
```

`operation` is either `upsert` or `delete`. `upsert` must insert/replace the
event using its `id` and schedule/show the notification instruction. `delete`
must remove the event identified by `taskId`; its `event.deleted` value is also
`true` and `notification.show` is `false`.

The `event` object is the same plaintext object Kairos encrypts before sending
the Nostr kind-30078 event: its coordinate is `epochs:<taskId>`. Astraea must
validate the protocol and version, parse the event with its normal bounds, then
write it through its ordinary local store so calendar views and widgets refresh.

The notification is deliberately explicit. Astraea should deduplicate by
`dedupeKey`, and should not publish this local command back to Nostr. Receiving
the command is the instruction to display the task and notify the user; Nostr
is only the independent durable synchronization path.

## Linux registration

On Linux Astraea should listen on the Unix-domain socket
`$XDG_RUNTIME_DIR/astraea-kairos.sock`. Kairos writes exactly one UTF-8 JSON
message followed by `\n` per connection and closes the connection. The runtime
directory is used instead of `/tmp` so another user cannot impersonate the
receiver. The same envelope and idempotency rules apply as on Android.
