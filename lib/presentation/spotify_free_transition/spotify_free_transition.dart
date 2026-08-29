import 'package:flutter/material.dart';

import '../resource/color_manager.dart';

class SpotifyFreeTransition extends StatelessWidget {
  const SpotifyFreeTransition({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.bagroundColor,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 1, color: Color(0X33CDBDFF)),
            ),
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
      ),
      body: Container(),
    );
  }
}
