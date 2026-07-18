import 'package:flutter/material.dart';
import '../core/feel.dart';
import '../core/realms.dart';
import '../core/strings.dart';
import '../main.dart';
import '../widgets/companion.dart';
import 'parent_zone.dart';
import 'realm_screen.dart';

/// The hub: warm sky, the progress tree, Ondo bouncing, one door (Scene 1),
/// and a small parent corner. Entirely text-free for the child.
class HubScreen extends StatefulWidget {
  const HubScreen({super.key});
  @override
  State<HubScreen> createState() => _HubScreenState();
}

class _HubScreenState extends State<HubScreen> {
  bool _goodnight = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    AppStateScope.of(context).onSessionEnd = () {
      if (mounted) setState(() => _goodnight = true);
      // Return to hub if a scene is open.
      Navigator.of(context).popUntil((r) => r.isFirst);
    };
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    if (_goodnight) return _GoodnightScreen(onParentUnlock: () {
      setState(() => _goodnight = false);
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Progress tree, top-left: one leaf per completed activity.
              Positioned(
                left: 20,
                top: 12,
                child: _ProgressTree(leaves: state.leaves),
              ),
              // Session countdown dot (only visible when a session runs).
              if (state.sessionActive)
                Positioned(
                  top: 16,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: _SunsetDot(left: state.sessionLeft!),
                  ),
                ),
              // Parent corner, top-right: small, dull, hold-to-open.
              Positioned(
                right: 16,
                top: 12,
                child: _ParentCornerButton(onOpened: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ParentZone()));
                }),
              ),
              // Realm map: one door per realm, laid out as "islands".
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Wrap(
                    spacing: 28,
                    runSpacing: 24,
                    alignment: WrapAlignment.center,
                    children: [
                      for (final realm in kRealms)
                        _RealmDoor(
                          realm: realm,
                          unlocked: !realm.locked || state.isUnlocked(realm.id),
                          onTap: () {
                            Feel.tap();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => RealmScreen(realm: realm)));
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One island door per realm. Locked realms show dimmed with a lock badge —
/// still visible (drives "I want that one!"), tapping opens the paywall
/// sheet inside RealmScreen rather than blocking navigation entirely.
class _RealmDoor extends StatelessWidget {
  final RealmDef realm;
  final bool unlocked;
  final VoidCallback onTap;
  const _RealmDoor(
      {required this.realm, required this.unlocked, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: unlocked ? 1 : .55,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Companion(color: realm.color, size: 90),
                if (!unlocked)
                  const Positioned(
                    bottom: 0,
                    right: 0,
                    child: Icon(Icons.lock_rounded,
                        size: 22, color: Colors.black54),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(S.t(realm.labelKey),
                style: const TextStyle(fontSize: 12, color: Colors.brown)),
          ],
        ),
      ),
    );
  }
}

class _ProgressTree extends StatelessWidget {
  final int leaves;
  const _ProgressTree({required this.leaves});
  @override
  Widget build(BuildContext context) {
    final shown = leaves.clamp(0, 12);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.park_rounded, size: 56, color: Color(0xFF6D4C41)),
        SizedBox(
          width: 120,
          child: Wrap(
            spacing: 2,
            children: List.generate(
                shown,
                (_) => const Icon(Icons.eco_rounded,
                    size: 16, color: Color(0xFF66BB6A))),
          ),
        ),
      ],
    );
  }
}

class _SunsetDot extends StatelessWidget {
  final Duration left;
  const _SunsetDot({required this.left});
  @override
  Widget build(BuildContext context) {
    // Wordless: a sun that lowers as time runs out. Under 2 min it warms up.
    final warning = left.inSeconds < 120;
    return Icon(
      warning ? Icons.wb_twilight_rounded : Icons.wb_sunny_rounded,
      color: warning ? Colors.deepOrange : Colors.amber,
      size: 30,
    );
  }
}

/// Hold-for-3-seconds gate. Impossible for young kids by accident,
/// trivial for parents; standard kids-category pattern.
class _ParentCornerButton extends StatefulWidget {
  final VoidCallback onOpened;
  const _ParentCornerButton({required this.onOpened});
  @override
  State<_ParentCornerButton> createState() => _ParentCornerButtonState();
}

class _ParentCornerButtonState extends State<_ParentCornerButton> {
  double _progress = 0;
  bool _holding = false;

  Future<void> _startHold() async {
    _holding = true;
    const step = Duration(milliseconds: 100);
    while (_holding && _progress < 1) {
      await Future.delayed(step);
      if (!mounted) return;
      setState(() => _progress += 0.1 / 3);
    }
    if (_holding && _progress >= 1) {
      widget.onOpened();
    }
    setState(() => _progress = 0);
    _holding = false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (_) => _startHold(),
      onLongPressEnd: (_) => _holding = false,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 44,
            height: 44,
            child: CircularProgressIndicator(
                value: _progress, strokeWidth: 3, color: Colors.brown),
          ),
          const Icon(Icons.family_restroom_rounded,
              size: 24, color: Colors.brown),
        ],
      ),
    );
  }
}

class _GoodnightScreen extends StatelessWidget {
  final VoidCallback onParentUnlock;
  const _GoodnightScreen({required this.onParentUnlock});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A237E),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Companion(color: Color(0xFF4DB6AC), size: 130, sleepy: true),
                  const SizedBox(height: 16),
                  Text(S.t('goodnight'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 18)),
                ],
              ),
            ),
            Positioned(
              right: 16,
              top: 12,
              child: _ParentCornerButton(onOpened: onParentUnlock),
            ),
          ],
        ),
      ),
    );
  }
}
