import 'package:flutter/material.dart';

class LoadingDots extends StatefulWidget {
final AnimationController controller;
  const LoadingDots({ super.key,required this.controller });

  @override
  State<LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<LoadingDots> with SingleTickerProviderStateMixin {
 static const _dotCount = 5;
  static const _dotColors = [
    Color(0xFF6C5CE7),
    Color(0xFF9C4FE0),
    Color(0xFFE84BC7),
    Color(0xFFFF6F5C),
    Color(0xFFFF8A3D),
  ];

  late final AnimationController _loop;

  @override
  void initState() {
    super.initState();
    _loop = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _loop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([widget.controller, _loop]),
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(_dotCount, (i) {
            final delay = i / _dotCount;
            final t = ((_loop.value - delay) % 1.0 + 1.0) % 1.0;
            final pulse = Curves.easeInOut.transform(
              t < 0.5 ? 1 - (t * 2) : (t - 0.5) * 2,
            );
            final color = Color.lerp(
              Colors.grey.shade800,
              _dotColors[i],
              pulse,
            );
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Transform.scale(
                scale: 0.85 + (0.15 * pulse),
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}