import 'dart:math';
import 'package:flutter/material.dart';
import '../core/feel.dart';
import '../core/realms.dart';
import '../core/strings.dart';
import '../main.dart';
import '../widgets/companion.dart';

class SortingScene extends StatefulWidget {
  final RealmDef realm;
  final int level;
  const SortingScene({super.key, required this.realm, required this.level});
  @override
  State<SortingScene> createState() => _SortingSceneState();
}

class _Treasure {
  final int id;
  final Color color;
  final IconData icon;
  Offset pos;
  bool sorted = false;
  _Treasure(this.id, this.color, this.icon, this.pos);
}

class _SortingSceneState extends State<SortingScene> {
  static const _palette = [
    Color(0xFFE53935),
    Color(0xFF1E88E5),
    Color(0xFFFDD835),
    Color(0xFF43A047),
  ];
  static const _icons = [
    Icons.star_rounded,
    Icons.favorite_rounded,
    Icons.circle,
    Icons.pets_rounded,
    Icons.anchor_rounded,
    Icons.cake_rounded,
  ];

  late List<_Treasure> _treasures;
  late int _colorCount;
  bool _celebrating = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ageBand = AppStateScope.of(context).ageBand;
    _colorCount = (ageBand == 0 ? 2 : 3) + (widget.level > 3 ? 1 : 0);
    _colorCount = _colorCount.clamp(2, _palette.length);
    _reset();
  }

  void _reset() {
    final rnd = Random();
    _treasures = List.generate(_colorCount * 3, (i) {
      return _Treasure(
        i,
        _palette[i % _colorCount],
        _icons[rnd.nextInt(_icons.length)],
        Offset(80.0 + rnd.nextDouble() * 300, 60.0 + rnd.nextDouble() * 120),
      );
    });
    _celebrating = false;
  }

  void _onDropped(_Treasure t, Color basketColor) {
    if (t.color == basketColor) {
      setState(() => t.sorted = true);
      Feel.success();
      if (_treasures.every((x) => x.sorted)) _finish();
    } else {
      Feel.gentleNo();
    }
  }

  Future<void> _finish() async {
    setState(() => _celebrating = true);
    Feel.celebrate();
    final state = AppStateScope.of(context);
    state.addLeaf('sort_${widget.realm.id}');
    state.advanceLevel(widget.realm.id);
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) setState(_reset);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFFFF8E1),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                left: 12,
                top: 12,
                child: IconButton(
                  iconSize: 40,
                  icon: const Icon(Icons.arrow_back_rounded,
                      color: Colors.brown),
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
                left: 24,
                bottom: 16,
                child: Column(
                  children: [
                    if (_celebrating)
                      const Icon(Icons.auto_awesome_rounded,
                          size: 36, color: Colors.amber),
                    Companion(color: widget.realm.color, size: 120),
                  ],
                ),
              ),
              for (final t in _treasures)
                if (!t.sorted)
                  Positioned(
                    left: t.pos.dx,
                    top: t.pos.dy,
                    child: Draggable<_Treasure>(
                      data: t,
                      feedback: Icon(t.icon, size: 56, color: t.color),
                      childWhenDragging: const SizedBox(width: 48, height: 48),
                      child: Icon(t.icon, size: 48, color: t.color),
                    ),
                  ),
              Positioned(
                right: 20,
                bottom: 20,
                child: Row(
                  children: [
                    for (var i = 0; i < _colorCount; i++)
                      Padding(
                        padding: const EdgeInsets.only(left: 14),
                        child: _Basket(
                          color: _palette[i],
                          count: _treasures
                              .where((t) => t.sorted && t.color == _palette[i])
                              .length,
                          onAccept: (t) => _onDropped(t, _palette[i]),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
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
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(S.t('sortSkill')),
            const SizedBox(height: 8),
            Text(S.t('sortApproach')),
            const SizedBox(height: 8),
            Text(S.t('sortHome'),
                style: const TextStyle(fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }
}

class
