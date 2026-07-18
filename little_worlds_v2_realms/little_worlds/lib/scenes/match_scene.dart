import 'dart:math';
import 'package:flutter/material.dart';
import '../core/feel.dart';
import '../core/realms.dart';
import '../core/strings.dart';
import '../main.dart';
import '../widgets/companion.dart';

/// SCENE — "Town: Match the Shopkeepers"
/// Classic pairs/memory game: flip two icons, matching pair stays revealed.
/// HighScope plan-do-review framing: child freely chooses which cards to
/// flip (plan), flips (do), sees the result (review) — no timer pressure.
/// Grid size scales with level (more pairs = harder), which is the whole
/// "add-on deepens easily" pattern: level N+1 just adds one more pair.
class MatchScene extends StatefulWidget {
  final RealmDef realm;
  final int level;
  const MatchScene({super.key, required this.realm, required this.level});
  @override
  State<MatchScene> createState() => _MatchSceneState();
}

class _Card {
  final int pairId;
  final IconData icon;
  bool revealed = false;
  bool matched = false;
  _Card(this.pairId, this.icon);
}

class _MatchSceneState extends State<MatchScene> {
  static const _icons = [
    Icons.storefront_rounded,
    Icons.local_florist_rounded,
    Icons.icecream_rounded,
    Icons.pedal_bike_rounded,
    Icons.umbrella_rounded,
    Icons.emoji_food_beverage_rounded,
    Icons.local_post_office_rounded,
    Icons.bakery_dining_rounded,
  ];

  late List<_Card> _cards;
  List<int> _flipped = [];
  bool _busy = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reset();
  }

  void _reset() {
    final pairCount = (3 + widget.level).clamp(3, _icons.length);
    final rnd = Random();
    final chosen = (_icons.toList()..shuffle(rnd)).take(pairCount).toList();
    _cards = [
      for (var i = 0; i < chosen.length; i++) ...[
        _Card(i, chosen[i]),
        _Card(i, chosen[i]),
      ]
    ]..shuffle(rnd);
    _flipped = [];
    _busy = false;
  }

  Future<void> _tap(int i) async {
    if (_busy || _cards[i].revealed || _cards[i].matched) return;
    Feel.tap();
    setState(() => _cards[i].revealed = true);
    _flipped.add(i);
    if (_flipped.length == 2) {
      _busy = true;
      final a = _cards[_flipped[0]];
      final b = _cards[_flipped[1]];
      await Future.delayed(const Duration(milliseconds: 500));
      if (a.pairId == b.pairId) {
        Feel.success();
        setState(() {
          a.matched = true;
          b.matched = true;
        });
        if (_cards.every((c) => c.matched)) _finish();
      } else {
        Feel.gentleNo();
        setState(() {
          a.revealed = false;
          b.revealed = false;
        });
      }
      _flipped = [];
      _busy = false;
    }
  }

  Future<void> _finish() async {
    Feel.celebrate();
    final state = AppStateScope.of(context);
    state.addLeaf('match_${widget.realm.id}');
    state.advanceLevel(widget.realm.id);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(_reset);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.realm.color.withOpacity(.06),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  iconSize: 40,
                  icon: const Icon(Icons.arrow_back_rounded, color: Colors.brown),
                  onPressed: () {
                    Feel.tap();
                    Navigator.of(context).pop();
                  },
                ),
                Companion(color: widget.realm.color, size: 60),
                IconButton(
                  iconSize: 30,
                  icon: const Icon(Icons.eco_rounded, color: Color(0xFF66BB6A)),
                  onPressed: () => _showWhyThis(context),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children: List.generate(_cards.length, (i) {
                    final c = _cards[i];
                    final show = c.revealed || c.matched;
                    return GestureDetector(
                      onTap: () => _tap(i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: c.matched
                              ? widget.realm.color.withOpacity(.2)
                              : (show
                                  ? Colors.white
                                  : widget.realm.color.withOpacity(.7)),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: widget.realm.color, width: 2),
                        ),
                        child: Center(
                          child: show
                              ? Icon(c.icon, size: 30, color: widget.realm.color)
                              : const Icon(Icons.help_outline_rounded,
                                  color: Colors.white70),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showWhyThis(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(S.t('whyThis'),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(S.t('matchSkill')),
            const SizedBox(height: 8),
            Text(S.t('matchApproach')),
            const SizedBox(height: 8),
            Text(S.t('matchHome'), style: const TextStyle(fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }
}
