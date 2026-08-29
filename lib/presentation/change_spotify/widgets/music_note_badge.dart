import 'package:flutter/material.dart';

import '../../resource/color_manager.dart';

class MusicNoteBadge extends StatelessWidget {
  const MusicNoteBadge({super.key, this.size = 44});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.002),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 0),
            color: const Color(0xFFFF469E),
            blurRadius: 15,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ColorManager.bagroundColor,
        ),
        child: Icon(
          Icons.music_note,
          color: const Color(0xFFFF469E),
          size: size * 0.55,
        ),
      ),
    );
  }
}
