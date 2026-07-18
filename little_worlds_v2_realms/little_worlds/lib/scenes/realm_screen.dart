import 'package:flutter/material.dart';
import '../core/feel.dart';
import '../core/realms.dart';
import '../core/strings.dart';
import '../main.dart';
import '../widgets/companion.dart';
import 'sorting_scene.dart';
import 'match_scene.dart';
import 'search_scene.dart';

/// Shows a simple level path for one realm. Levels beyond freeLevels are
/// locked until the realm is unlocked (parent-gated stub purchase).
/// This screen is genre-agnostic: it just picks which mini-game widget
/// to launch based on RealmDef.kind, so a brand-new realm with an
/// EXISTING genre needs zero new game code — only a new RealmDef entry.
class RealmScreen extends StatelessWidget {
  final RealmDef realm;
  const RealmScreen({super.key, required this.realm});

  void _play(BuildContext context, int level) {
    Feel.tap();
    Widget scene;
    switch (realm.kind) {
      case GameKind.sorting:
        scene = SortingScene(realm: realm, level: level);
        break;
      case GameKind.matchPairs:
        scene = MatchScene(realm: realm, level: level);
        break;
      case GameKind.hiddenSearch:
        scene = SearchScene(realm: realm, level: level);
        break;
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => scene));
  }

  void _showPaywall(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(S.t('unlockTitle'),
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(S.t('unlockBody')),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(S.t('cancel')),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      // Stub: wire real StoreKit2 / Play Billing here.
                      AppStateScope.of(context).unlockRealm(realm.id);
                      Navigator.pop(context);
                    },
                    child: Text(S.t('unlockPrice')),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final unlocked = !realm.locked || state.isUnlocked(realm.id);
    final availableLevels = unlocked ? realm.totalLevels : realm.freeLevels;

    return Scaffold(
      backgroundColor: realm.color.withOpacity(.08),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(S.t(realm.labelKey)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Companion(color: realm.color, size: 90),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                children: List.generate(realm.totalLevels, (i) {
                  final level = i + 1;
                  final isLocked = level > availableLevels;
                  return GestureDetector(
                    onTap: () =>
                        isLocked ? _showPaywall(context) : _play(context, level),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isLocked
                            ? Colors.grey.shade300
                            : realm.color.withOpacity(.25),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: isLocked ? Colors.grey : realm.color,
                            width: 3),
                      ),
                      child: Center(
                        child: isLocked
                            ? const Icon(Icons.lock_rounded, color: Colors.grey)
                            : Text('$level',
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                      ),
                    ),
                  );
                }),
              ),
            ),
            if (realm.totalLevels == 0)
              Text(S.t('comingSoon'), style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
