import 'package:flutter/material.dart';

import 'center_graphic.dart';
import 'music_note_badge.dart';

class SpotifyConnectGraphic extends StatefulWidget {
  const SpotifyConnectGraphic({super.key});

  @override
  State<SpotifyConnectGraphic> createState() => _SpotifyConnectGraphicState();
}

class _SpotifyConnectGraphicState extends State<SpotifyConnectGraphic>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _topRightBounce;
  late final Animation<double> _bottomLeftBounce;

  static final _jump = Tween<double>(begin: 0, end: -10);
  static final _idle = ConstantTween<double>(0);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _topRightBounce = TweenSequence<double>([
      TweenSequenceItem(
        tween: _jump.chain(CurveTween(curve: Curves.easeOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: -10.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 25,
      ),
      TweenSequenceItem(tween: _idle, weight: 50),
    ]).animate(_controller);

    _bottomLeftBounce = TweenSequence<double>([
      TweenSequenceItem(tween: _idle, weight: 50),
      TweenSequenceItem(
        tween: _jump.chain(CurveTween(curve: Curves.easeOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: -10.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 25,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _bouncing(Animation<double> bounce, Widget child) {
    return AnimatedBuilder(
      animation: bounce,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, bounce.value),
          child: child,
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 320,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const CenterGraphic(),
          Positioned(
            top: 16,
            right: 16,
            child: _bouncing(_topRightBounce, const MusicNoteBadge()),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: _bouncing(_bottomLeftBounce, const MusicNoteBadge()),
          ),
        ],
      ),
    );
  }
}
