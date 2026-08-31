import 'package:flutter/material.dart';

class ScannerOverlay extends StatefulWidget {
  const ScannerOverlay({super.key});

  @override
  State<ScannerOverlay> createState() => _ScannerOverlayState();
}

class _ScannerOverlayState extends State<ScannerOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scanController;
  late final Animation<double> _scanPosition;

  static const _pink = Color(0xFFFF1B8D);
  static const _purple = Color(0xFF6C2BFF);

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();
    _scanPosition = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _scanController, curve: Curves.linear));
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IgnorePointer(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 0.85,
                colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
                stops: const [0.4, 1.0],
              ),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.08),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    child: const Icon(Icons.close, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 260,
                height: 260,
                child: AnimatedBuilder(
                  animation: _scanPosition,
                  builder: (context, _) {
                    return Stack(
                      children: [
                        _corner(top: 0, left: 0, borders: const [
                          _CornerSide.top,
                          _CornerSide.left,
                        ]),
                        _corner(top: 0, right: 0, borders: const [
                          _CornerSide.top,
                          _CornerSide.right,
                        ]),
                        _corner(bottom: 0, left: 0, borders: const [
                          _CornerSide.bottom,
                          _CornerSide.left,
                        ]),
                        _corner(bottom: 0, right: 0, borders: const [
                          _CornerSide.bottom,
                          _CornerSide.right,
                        ]),
                        Positioned(
                          top: 260 * _scanPosition.value - 1,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 2,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF6C2BFF),
                                  Color(0xFFFFB0CB),
                                  Color(0xFF6C2BFF),
                                ],
                                stops: [0.0, 0.5, 1.0],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: _purple.withValues(alpha: 0.8),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: Opacity(
                            opacity: 0.3,
                            child: Icon(
                              Icons.crop_free,
                              color: Colors.white,
                              size: 48,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 64),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Escaneie o verso da próxima carta Beatspan',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    shadows: [Shadow(color: Colors.black45, blurRadius: 4)],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _corner({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required List<_CornerSide> borders,
  }) {
    const side = BorderSide(color: _pink, width: 4);
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          border: Border(
            top: borders.contains(_CornerSide.top) ? side : BorderSide.none,
            bottom: borders.contains(_CornerSide.bottom)
                ? side
                : BorderSide.none,
            left: borders.contains(_CornerSide.left) ? side : BorderSide.none,
            right: borders.contains(_CornerSide.right)
                ? side
                : BorderSide.none,
          ),
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(color: _pink.withValues(alpha: 0.5), blurRadius: 15),
          ],
        ),
      ),
    );
  }
}

enum _CornerSide { top, bottom, left, right }
