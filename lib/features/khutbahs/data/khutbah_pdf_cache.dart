import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'khutbah_constants.dart';
import 'khutbah_models.dart';

class KhutbahPdfCache {
  KhutbahPdfCache({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  Directory? _cacheDir;

  Future<Directory> _ensureCacheDir() async {
    if (_cacheDir != null) return _cacheDir!;
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory('${base.path}/${KhutbahConstants.cacheDirName}');
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    _cacheDir = dir;
    return dir;
  }

  File _fileForId(int id) {
    final dir = _cacheDir!;
    return File('${dir.path}/$id.pdf');
  }

  Future<File?> getCachedFile(int id) async {
    await _ensureCacheDir();
    final file = _fileForId(id);
    if (!file.existsSync()) return null;
    if (!_isValidPdfFile(file)) {
      await file.delete();
      return null;
    }
    await _touch(file);
    return file;
  }

  Future<File> download(
    KhutbahIndexEntry entry, {
    void Function(double progress)? onProgress,
  }) async {
    if (!entry.hasPdf) {
      throw const HttpException('Khutbah has no PDF attachment');
    }

    final cached = await getCachedFile(entry.id);
    if (cached != null) return cached;

    await _ensureCacheDir();
    final target = _fileForId(entry.id);
    final temp = File('${target.path}.part');

    Exception? lastError;
    for (var attempt = 0; attempt < 3; attempt++) {
      if (attempt > 0) {
        await Future<void>.delayed(Duration(seconds: attempt));
      }
      try {
        final request = http.Request('GET', Uri.parse(entry.pdfUrl));
        final response = await _client
            .send(request)
            .timeout(KhutbahConstants.downloadTimeout);

        if (response.statusCode != 200) {
          throw HttpException('PDF download failed (${response.statusCode})');
        }

        final total = response.contentLength ?? 0;
        var received = 0;
        final sink = temp.openWrite();

        await for (final chunk in response.stream) {
          received += chunk.length;
          sink.add(chunk);
          if (total > 0 && onProgress != null) {
            onProgress(received / total);
          }
        }
        await sink.close();

        if (!_isValidPdfFile(temp)) {
          await temp.delete();
          throw const HttpException('Downloaded file is not a valid PDF');
        }

        if (target.existsSync()) {
          await target.delete();
        }
        await temp.rename(target.path);
        await _enforceLimits();
        return target;
      } catch (error) {
        lastError = error is Exception ? error : Exception('$error');
        if (temp.existsSync()) {
          await temp.delete();
        }
      }
    }

    throw lastError ?? Exception('PDF download failed');
  }

  Future<void> _touch(File file) async {
    final now = DateTime.now();
    file.setLastAccessedSync(now);
    file.setLastModifiedSync(now);
  }

  bool _isValidPdfFile(File file) {
    if (!file.existsSync()) return false;
    if (file.lengthSync() < KhutbahConstants.minValidPdfBytes) return false;

    final raf = file.openSync(mode: FileMode.read);
    try {
      final header = raf.readSync(5);
      if (header.length < 5) return false;
      return header[0] == 0x25 && // %
          header[1] == 0x50 && // P
          header[2] == 0x44 && // D
          header[3] == 0x46 && // F
          header[4] == 0x2D; // -
    } finally {
      raf.closeSync();
    }
  }

  Future<void> _enforceLimits() async {
    await _ensureCacheDir();
    final files = _cacheDir!
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.pdf'))
        .toList()
      ..sort(
        (a, b) => b.lastAccessedSync().compareTo(a.lastAccessedSync()),
      );

    var totalBytes = files.fold<int>(0, (sum, f) => sum + f.lengthSync());

    for (var i = 0; i < files.length; i++) {
      final overCount = i >= KhutbahConstants.maxCachedFiles;
      final overSize = totalBytes > KhutbahConstants.maxCacheBytes;
      if (!overCount && !overSize) break;
      totalBytes -= files[i].lengthSync();
      await files[i].delete();
    }
  }

  void dispose() {
    _client.close();
  }
}
