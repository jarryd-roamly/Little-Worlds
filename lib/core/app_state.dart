import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  final SharedPreferences _prefs;
  AppState._(this._prefs);

  static Future<AppState> load() async =>
      AppState._(await SharedPreferences.getInstance());

  String get childName => _prefs.getString('childName') ?? '';
  set childName(String v) {
    _prefs.setString('childName', v.trim());
    notifyListeners();
  }

  int get ageBand => _prefs.getInt('ageBand') ?? 0;
  set ageBand(int v) {
    _prefs.setInt('ageBand', v);
    notifyListeners();
  }

  String get locale => _prefs.getString('locale') ?? 'en';
  set locale(String v) {
    _prefs.setString('locale', v);
    notifyListeners();
  }

  int get leaves => _prefs.getInt('leaves') ?? 0;
  void addLeaf(String activityId) {
    _prefs.setInt('leaves', leaves + 1);
    final key = 'done_$activityId';
    _prefs.setInt(key, (_prefs.getInt(key) ?? 0) + 1);
    notifyListeners();
  }

  int completions(String activityId) => _prefs.getInt('done_$activityId') ?? 0;

  bool isUnlocked(String realmId) =>
      _prefs.getBool('unlocked_$realmId') ?? false;

  void unlockRealm(String realmId) {
    _prefs.setBool('unlocked_$realmId', true);
    notifyListeners();
  }

  int levelReached(String realmId) => _prefs.getInt('level_$realmId') ?? 0;
  void advanceLevel(String realmId) {
    _prefs.setInt('level_$realmId', levelReached(realmId) + 1);
    notifyListeners();
  }

  Timer? _sessionTimer;
  Duration? _sessionLeft;
  Duration? get sessionLeft => _sessionLeft;
  bool get sessionActive => _sessionTimer != null;
  VoidCallback? onSessionEnd;

  void startSession(Duration length) {
    _sessionTimer?.cancel();
    _sessionLeft = length;
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _sessionLeft = _sessionLeft! - const Duration(seconds: 1);
      if (_sessionLeft!.inSeconds <= 0) {
        stopSession();
        onSessionEnd?.call();
      }
      notifyListeners();
    });
    notifyListeners();
  }

  void stopSession() {
    _sessionTimer?.cancel();
    _sessionTimer = null;
    _sessionLeft = null;
    notifyListeners();
  }
}
