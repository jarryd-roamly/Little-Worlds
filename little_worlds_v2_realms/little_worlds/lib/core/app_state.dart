import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// All persistent, local-only state. No accounts, no network, no child PII
/// beyond an optional display name typed by the parent. COPPA-minimal.
class AppState extends ChangeNotifier {
  final SharedPreferences _prefs;
  AppState._(this._prefs);

  static Future<AppState> load() async =>
      AppState._(await SharedPreferences.getInstance());

  // ---------- Parent-entered settings ----------
  String get childName => _prefs.getString('childName') ?? '';
  set childName(String v) {
    _prefs.setString('childName', v.trim());
    notifyListeners();
  }

  /// Age band index: 0 = 3-5, 1 = 4-6, 2 = 5-7, 3 = 6-8
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

  // ---------- Progress tree (leaves = completed activities) ----------
  int get leaves => _prefs.getInt('leaves') ?? 0;
  void addLeaf(String activityId) {
    _prefs.setInt('leaves', leaves + 1);
    // Per-activity completion + count, for the parent report.
    final key = 'done_$activityId';
    _prefs.setInt(key, (_prefs.getInt(key) ?? 0) + 1);
    notifyListeners();
  }

  int completions(String activityId) => _prefs.getInt('done_$activityId') ?? 0;

  // ---------- Realm unlocks (purchases) ----------
  // MVP: local flag flipped by a stub "purchase" call. Wire real StoreKit /
  // Play Billing here later — every other screen just reads isUnlocked().
  bool isUnlocked(String realmId) =>
      _prefs.getBool('unlocked_$realmId') ?? false;

  void unlockRealm(String realmId) {
    _prefs.setBool('unlocked_$realmId', true);
    notifyListeners();
  }

  /// Highest level reached per realm, for the "10 free, then unlock" gate
  /// and for showing progress on the map.
  int levelReached(String realmId) => _prefs.getInt('level_$realmId') ?? 0;
  void advanceLevel(String realmId) {
    _prefs.setInt('level_$realmId', levelReached(realmId) + 1);
    notifyListeners();
  }

  // ---------- Restaurant Mode / session timer ----------
  Timer? _sessionTimer;
  Duration? _sessionLeft;
  Duration? get sessionLeft => _sessionLeft;
  bool get sessionActive => _sessionTimer != null;
  VoidCallback? onSessionEnd; // HubScreen wires this to the goodnight ritual

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
