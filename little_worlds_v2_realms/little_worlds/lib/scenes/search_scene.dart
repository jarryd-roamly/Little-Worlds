import 'dart:math';
import 'package:flutter/material.dart';
import '../core/feel.dart';
import '../core/realms.dart';
import '../core/strings.dart';
import '../main.dart';
import '../widgets/companion.dart';

/// SCENE — "Nature Island: Find the Hidden Creatures"
/// A busy scene (icon clutter) hides N target icons; child taps to find
/// them all. Reggio-style provocation: rich environment, self-paced,
/// no penalty for wrong taps beyond a gentle non-response.
/// Level scales target count and clutter density.
class SearchScene extends StatefulWidget {
  final RealmDef realm;
  final int level;
  const SearchScene({super.key, required this.realm, required this.level});
  @override
  State<SearchScene> createState() => _SearchSceneState();
}

class _Spot {
  final Offset pos;
  final IconData icon;
  final bool isTarget;
  bool found = false;
  _Spot(this.pos, this.icon, this.isTarget);
}

class _SearchSceneState extends State<SearchScene> {
  static const _targetIcon = Icons.bug_report_rounded;
  static const _clutterIcons = [
    Icons.eco_rounded,
    Icons.grass_rounded,
    Icons.park_rounded,
    Icons.filter_vintage_rounded,
  ];

  late List<_Spot> _spots;
  int _targetCount = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reset();
  }

  void _reset() {
    final rnd = Random();
    _targetCount = (2 + widget.level).clamp(2, 8);
    final clutterCount = 14 + widget.level * 2;
    _spots = [
      for (var i = 0; i < _targetCount; i++)
        _Spot(
          Offset(30 + rnd.nextDouble() * 380, 30 + rnd.nextDouble() * 260),
          _targetIcon,
          true,
        ),
      for (var i = 0; i < clutterCount; i++)
        _Spot(
          Offset(30 + rnd.nextDouble() * 380, 30 + rnd.nextDouble() * 260),
          _clutterIcons[rnd.nextInt(_clutterIcons.length)],
          false,
        ),
    ];
  }

  void _tap(_Spot s) {
    if (!s.isTarget || s.found) {
      if (s.isTarget == false) Feel.tap();
      return;
    }
    Feel.success();
    setState(() => s.found = true);
    if (_spots.where((x) => x.isTarget).every((x) => x.found)) _finish();
  }

  Future<void> _finish() async {
    Feel.celebrate();
    final state = AppStateScope.of(context);
    state.addLeaf('search_${widget.realm.id}');
    state.advanceLevel(widget.realm.id);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(_reset);
  }

  @override
  Widget build(BuildContext context) {
    final foundCount = _spots.where((s) => s.isTarget && s.found).length;
    return Scaffold(
      backgroundColor: widget.realm.color.withOpacity(.08),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              left: 12,
              top: 12,
              child: IconButton(
                iconSize: 40,
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.brown),
                onPressed: () {
                  Feel.tap();
                  Navigator.of(context).pop();
                },
              ),
            ),
            Positioned(
              right: 12,
              top: 12,
              child: IconButton(
                iconSize: 30,
                icon: const Icon(Icons.eco_rounded, color: Color(0xFF66BB6A)),
                onPressed: () => _showWhyThis(context),
              ),
            ),
            Positioned(
              top: 16,
              left: 0,
              right: 0,
              child: Center(
                child: Text('$foundCount / $_targetCount',
                    style: const TextStyle(fontSize: 18, color: Colors.brown)),
              ),
            ),
            for (final s in _spots)
              if (!(s.isTarget && s.found))
                Positioned(
                  left: s.pos.dx,
                  top: s.pos.dy,
                  child: GestureDetector(
                    onTap: () => _tap(s),
                    child: Icon(s.icon,
                        size: s.isTarget ? 30 : 26,
                        color: s.isTarget
                            ? widget.realm.color
                            : widget.realm.color.withOpacity(.35)),
                  ),
                ),
            Positioned(
              left: 20,
              bottom: 16,
              child: Companion(color: widget.realm.color, size: 70),
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
            Text(S.t('searchSkill')),
            const SizedBox(height: 8),
            Text(S.t('searchApproach')),
            const SizedBox(height: 8),
            Text(S.t('searchHome'), style: const TextStyle(fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }
}
