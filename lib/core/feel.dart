import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

class Feel {
  static final _player = AudioPlayer();

  static Future<void> tap() async {
    _buzz(15);
    _play('pop.mp3');
  }

  static Future<void> success() async {
    _buzz(30);
    _play('chime.mp3');
  }

  static Future<void> gentleNo() async {
    _play('boing.mp3');
  }

  static Future<void> celebrate() async {
    _buzz(60);
    _play('celebrate.mp3');
  }

  static Future<void> _play(String file) async {
    try {
      await _player.play(AssetSource('audio/$file'));
    } catch (_) {}
  }

  static Future<void> _buzz(int ms) async {
    try {
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(duration: ms, amplitude: 60);
      }
    } catch (_) {}
  }
}
