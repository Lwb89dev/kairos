import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

import '../utils/logger.dart';

/// A flat, app-private disk cache keyed by an opaque string id (the caller
/// picks the id — e.g. a sha256 of a URL), currently backing the profile
/// avatar.
///
/// Lives under [getApplicationCacheDirectory], which is explicitly OS-level
/// "safe to delete under storage pressure" and never exposed to other apps or
/// the user's shared photo library — unlike the public downloads or pictures
/// directories.
class FileCacheService {
  Directory? _cacheDir;

  Future<Directory> get _dir async {
    final cached = _cacheDir;
    if (cached != null) return cached;
    final base = await getApplicationCacheDirectory();
    final dir = Directory('${base.path}/kairos_files');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    _cacheDir = dir;
    return dir;
  }

  /// Returns the cached file for [key], or null if nothing is cached yet.
  Future<File?> get(String key, {String extension = ''}) async {
    _validatePathPart(key, extension);
    final dir = await _dir;
    final file = File('${dir.path}/$key$extension');
    return file.existsSync() ? file : null;
  }

  /// Writes [bytes] to the cache under [key] and returns the resulting file.
  Future<File> put(String key, Uint8List bytes, {String extension = ''}) async {
    _validatePathPart(key, extension);
    debugLog('FileCacheService.put called', name: 'FileCacheService');
    final dir = await _dir;
    final file = File('${dir.path}/$key$extension');
    return file.writeAsBytes(bytes, flush: true);
  }

  void _validatePathPart(String key, String extension) {
    final safeKey = RegExp(r'^[a-zA-Z0-9_-]{1,128}$');
    final safeExtension = RegExp(r'^(\.[a-zA-Z0-9]{1,10})?$');
    if (!safeKey.hasMatch(key) || !safeExtension.hasMatch(extension)) {
      throw ArgumentError('Invalid cache key.');
    }
  }
}
