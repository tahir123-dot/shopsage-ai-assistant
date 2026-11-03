import 'package:flutter/material.dart';

Widget _blob(double size, List<Color> colors) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: RadialGradient(colors: colors),
    ),
  );
}

/// Halka purple saans leta hua gola
class Orb extends StatefulWidget {
  const Orb({super.key});

  @override
  State<Orb> createState() => _OrbState();
}

class _OrbState extends State<Orb> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, _) {
        final s = 0.94 + 0.12 * Curves.easeInOut.transform(_controller.value);
        return Transform.scale(
          scale: s,
          child: SizedBox(
            width: 260,
            height: 260,
            child: Stack(
              alignment: Alignment.center,
              children: [
                _blob(260, const [
                  Color(0xCCB79CFF),
                  Color(0x66D9C8FF),
                  Color(0x00FFFFFF),
                ]),
                Transform.translate(
                  offset: const Offset(-30, -25),
                  child: _blob(150, const [
                    Color(0xCCE7B5FF),
                    Color(0x00FFFFFF),
                  ]),
                ),
                Transform.translate(
                  offset: const Offset(30, 25),
                  child: _blob(150, const [
                    Color(0xCCA8B8FF),
                    Color(0x00FFFFFF),
                  ]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
