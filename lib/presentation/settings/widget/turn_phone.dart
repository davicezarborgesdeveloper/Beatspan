import 'package:flutter/material.dart';

class TurnPhone extends StatelessWidget {
  const TurnPhone({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Color(0XFF110B1A),
            border: Border.all(
              width: 1,
              color: Colors.white.withValues(alpha: 0.15),
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ),
          ),
        ),
        SizedBox(height: 8),
        Container(
           padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Color(0XFF110B1A),
            border: Border.all(
              width: 1,
              color: Colors.white.withValues(alpha: 0.15),
            ),
          ),
        ),
        SizedBox(height: 8),
         Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Color(0XFF110B1A),
            border: Border.all(
              width: 1,
              color: Colors.white.withValues(alpha: 0.15),
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12.0),
              bottomRight: Radius.circular(12.0),
            ),
          ),
        ),
      ],
    );
  }
}
