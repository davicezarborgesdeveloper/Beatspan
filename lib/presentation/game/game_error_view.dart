import 'package:flutter/material.dart';

import '../resource/color_manager.dart';
import '../resource/font_manager.dart';
import '../resource/screen_manager.dart';
import '../resource/style_manager.dart';
import '../share/widgets/scaffold_hitster.dart';

class GameErrorView extends StatefulWidget {
  const GameErrorView({super.key});

  @override
  State<GameErrorView> createState() => _GameErrorViewState();
}

class _GameErrorViewState extends State<GameErrorView> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldHitster(
      colorFst: ColorManager.quaternary,
      colorSnd: ColorManager.quaternaryLight,
      bubbles: 4,

      sndRoute: '/close',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 130.0),
                Text(
                  'OPS, CÓDIGO QR DESCONHECIDO',
                  style: getMediumStyle(
                    color: ColorManager.white,
                    fontSize: FontSize.s32,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.0),
                Text(
                  'Você escaneou um QR code que não pertece a nenhuma carta de Beatspan. Tente outra carta do jogo!',
                  style: getMediumStyle(
                    color: ColorManager.white,
                    fontSize: FontSize.s16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(64.0),
              child: SizedBox(
                height: 62.0,
                width: context.screenWidth,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Proxima carta',
                    style: getBoldStyle(
                      color: ColorManager.quaternaryLight,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
