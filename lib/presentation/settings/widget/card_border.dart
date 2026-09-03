import 'package:flutter/material.dart';

const kSelectedGradient = LinearGradient(
  colors: [Color(0XFF6C2BFF), Color(0XFFFF469E)],
  begin: AlignmentDirectional.bottomStart,
  end: AlignmentDirectional.topEnd,
);

class CardBorder extends StatelessWidget {
  const CardBorder({
    super.key,
    required this.selected,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(12.0)),
  });

  final bool selected;
  final Widget child;
  final BorderRadius borderRadius;

  static BorderRadius _inset(BorderRadius radius) => BorderRadius.only(
    topLeft: Radius.circular((radius.topLeft.x - 1).clamp(0, double.infinity)),
    topRight: Radius.circular(
      (radius.topRight.x - 1).clamp(0, double.infinity),
    ),
    bottomLeft: Radius.circular(
      (radius.bottomLeft.x - 1).clamp(0, double.infinity),
    ),
    bottomRight: Radius.circular(
      (radius.bottomRight.x - 1).clamp(0, double.infinity),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        gradient: selected ? kSelectedGradient : null,
        color: selected ? null : Colors.white.withValues(alpha: 0.15),
        borderRadius: borderRadius,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0XFF110B1A),
          borderRadius: _inset(borderRadius),
        ),
        child: child, 
      ),
    );  
  }
}
 