import 'package:flutter/material.dart';

class CenterGraphic extends StatelessWidget {
  const CenterGraphic({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 256,
      height: 256,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.002),
        shape: BoxShape.circle,
        border: Border.all(width: 2, color: Color(0XFF6824FC)),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF6824FC),
            blurRadius: 15, // Blur: 15
            spreadRadius: 0, // Spread: 0
            offset: Offset(0, 0), // Position X:0, Y:0
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0XFF110B1A),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.graphic_eq, size: 70),
      ),
    );
  }
}
