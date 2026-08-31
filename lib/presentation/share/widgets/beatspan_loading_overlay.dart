import 'package:flutter/material.dart';

class BeatspanLoadingOverlay extends StatefulWidget {
  final String message;
  final bool fillBackground;

  const BeatspanLoadingOverlay({
    super.key,
    this.message = 'BUSCANDO MÚSICA...',
    this.fillBackground = false,
  });

  @override
  State<BeatspanLoadingOverlay> createState() =>
      _BeatspanLoadingOverlayState();
}

class _BeatspanLoadingOverlayState extends State<BeatspanLoadingOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spinController;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RotationTransition(
            turns: _spinController,
            child: Container(
              width: 72,
              height: 72,
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: SweepGradient(
                  colors: [
                    Color(0xFF6C2BFF),
                    Color(0xFFE84BC7),
                    Color(0xFFFF8A3D),
                    Color(0xFF6C2BFF),
                  ],
                ),
              ),
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            widget.message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.0,
            ),
          ),
        ],
      ),
    );

    if (widget.fillBackground) {
      return ColoredBox(color: const Color(0xFF08050D), child: content);
    }

    return ColoredBox(
      color: Colors.black.withValues(alpha: 0.75),
      child: content,
    );
  }
}
