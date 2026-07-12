import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

/// Plays azan previews from bundled assets when the user picks a sound.
abstract final class AzanPreviewService {
  static AudioPlayer? _player;
  static String? _currentSound;

  static String? get currentSound => _currentSound;

  static bool get isReady => _player != null;

  static Stream<PlayerState>? get playerStateStream => _player?.playerStateStream;

  static AudioPlayer _ensurePlayer() {
    return _player ??= AudioPlayer();
  }

  static Future<bool> play(String soundId) async {
    try {
      final player = _ensurePlayer();

      if (_currentSound == soundId && player.playing) {
        await stop();
        return true;
      }

      await player.stop();
      _currentSound = soundId;
      await player.setAsset('assets/audio/$soundId.mp3');
      await player.seek(Duration.zero);
      await player.play();
      return true;
    } on MissingPluginException catch (error) {
      debugPrint('Azan preview plugin missing — full rebuild required: $error');
      _currentSound = null;
      return false;
    } catch (error, stackTrace) {
      debugPrint('Azan preview failed: $error');
      debugPrint('$stackTrace');
      _currentSound = null;
      return false;
    }
  }

  static Future<void> stop() async {
    try {
      await _player?.stop();
    } on MissingPluginException {
      // Hot restart before native plugin is registered — ignore.
    } catch (error) {
      debugPrint('Azan preview stop failed: $error');
    }
    _currentSound = null;
  }
}
