import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

import '../models/task_model.dart';
import '../utils/logger.dart';

/// The local, same-device protocol spoken by Kairos and Astraea.
///
/// Nostr is still the durable cross-device channel. This bridge is deliberately
/// a small Android app-to-app message: Astraea can update its own encrypted
/// local calendar immediately, without waiting for a relay round trip, and can
/// show the user a notification for the incoming task.
class AstraeaLocalBridge {
  AstraeaLocalBridge({Future<void> Function(String payload)? send})
    : _send = send ?? _sendThroughPlatform;

  static const protocol = 'dev.echoes.astraea.local';
  static const version = 1;
  static const _channel = MethodChannel('dev.echoes.kairos/astraea');
  static const socketFileName = 'astraea-kairos.sock';

  final Future<void> Function(String payload) _send;

  /// Tells Astraea to insert or replace the calendar event represented by
  /// [event]. The notification instruction is part of the same message, so
  /// Astraea never has to infer whether a local update deserves an alert.
  Future<void> upsert({
    required Task task,
    required Map<String, dynamic> event,
  }) async {
    await _dispatch(
      operation: 'upsert',
      task: task,
      event: event,
      notify: true,
    );
  }

  /// Tells Astraea to remove the task's local calendar event. Deletion is
  /// idempotent and can safely be retried after Astraea was not running.
  Future<void> delete({
    required Task task,
    required Map<String, dynamic> event,
  }) async {
    await _dispatch(
      operation: 'delete',
      task: task,
      event: event,
      notify: false,
    );
  }

  Future<void> _dispatch({
    required String operation,
    required Task task,
    required Map<String, dynamic> event,
    required bool notify,
  }) async {
    final message = <String, dynamic>{
      'protocol': protocol,
      'version': version,
      'source': 'kairos',
      'operation': operation,
      'taskId': task.id,
      // Astraea consumes this with its own Event.fromJson. It is not a Nostr
      // event and must never be re-published as one by the local receiver.
      'event': event,
      'notification': {
        'show': notify,
        'source': 'Kairos',
        'title': notify ? 'Task from Kairos' : null,
        'body': notify ? task.title : null,
        // The receiver uses this key to avoid duplicate alerts when Kairos
        // retries the same revision or Astraea receives the same intent twice.
        'dedupeKey':
            'kairos:${task.id}:${task.updatedAt.toUtc().millisecondsSinceEpoch}',
      },
    };
    final payload = jsonEncode(message);
    try {
      await _send(payload);
      SyncLog.nostr('local Astraea $operation ${task.id}');
    } on MissingPluginException {
      // Linux/test builds and older installs without the native channel still
      // have a fully working Nostr path. Local IPC is best effort by design.
      SyncLog.warn('ASTRAEA', 'Local bridge is unavailable on this platform');
    } on PlatformException catch (error) {
      // Astraea may not be installed. This must not turn a successful local
      // Kairos save or Nostr publish into a failed task mutation.
      SyncLog.warn('ASTRAEA', 'Local bridge could not deliver: ${error.code}');
    } catch (_) {
      SyncLog.warn('ASTRAEA', 'Local bridge could not deliver');
    }
  }

  static Future<void> _sendThroughPlatform(String payload) async {
    if (Platform.isAndroid) {
      await _channel.invokeMethod<void>('sendToAstraea', payload);
      return;
    }
    if (Platform.isLinux) {
      final runtimeDirectory = Platform.environment['XDG_RUNTIME_DIR'];
      if (runtimeDirectory == null || runtimeDirectory.isEmpty) {
        throw StateError('XDG_RUNTIME_DIR is not available');
      }
      final socket = await Socket.connect(
        InternetAddress(
          '$runtimeDirectory/$socketFileName',
          type: InternetAddressType.unix,
        ),
        0,
      ).timeout(const Duration(milliseconds: 750));
      try {
        socket.write('$payload\n');
        await socket.flush().timeout(const Duration(milliseconds: 750));
      } finally {
        socket.destroy();
      }
      return;
    }
    throw UnsupportedError('Astraea local IPC is unavailable on this platform');
  }
}
