import 'dart:math';
import 'package:flutter/material.dart';

/// V1 has no illustrated characters. Each realm has a "companion" — a soft
/// glowing orb in the realm's signature color that breathes, bobs, and
/// reacts with sound/haptics. Kids respond strongly to color, motion and
/// sound alone (pre-face-recognition engagement); this is intentionally
/// cheap and fast to build, and gets replaced by real character art in V2
/// once there's install/revenue data to justify commissioning it.
class Companion extends StatefulWidget {
  final Color color;
  final double size;
  final bool sleepy;
  const Companion(
      {super.key, required this.color, this.size = 110, this.sleepy = false});
  @override
  State<Companion> createState() => _CompanionState();
}

class _CompanionState extends State<Companion>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(seconds: 2))
        ..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) {
        final bob = sin(_c.value * pi) * (widget.sleepy ? 2 : 8);
        final scale = widget.sleepy ? 1.0 : 1.0 + _c.value * 0.06;
        return Transform.translate(
          offset: Offset(0, -bob),
          child: Transform.scale(
            scale: scale,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  widget.color.withOpacity(widget.sleepy ? .5 : 1),
                  widget.color.withOpacity(.6),
                ]),
              ),
              child: Center(
                child: Container(
                  width: widget.size * .4,
                  height: widget.sleepy ? 3 : widget.size * .4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
