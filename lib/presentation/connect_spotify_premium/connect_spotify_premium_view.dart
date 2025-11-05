import 'package:flutter/material.dart';

import '../resource/color_manager.dart';
import '../resource/font_manager.dart';
import '../resource/style_manager.dart';
import '../resource/value_manager.dart';
import '../share/widgets/scaffold_hitster.dart';

class ConnectSpotifyPremiumView extends StatefulWidget {
  const ConnectSpotifyPremiumView({super.key});

  @override
  State<ConnectSpotifyPremiumView> createState() =>
      _ConnectSpotifyPremiumViewState();
}

class _ConnectSpotifyPremiumViewState extends State<ConnectSpotifyPremiumView> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldHitster(
      sndRoute: '/close',
      bubbles: 3,
      colorFst: ColorManager.ternary,
      colorSnd: ColorManager.ternaryLight,
      child: Padding(
        padding: const EdgeInsets.only(
          top: AppPadding.p120,
          bottom: AppPadding.p120,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  'LIGAR COM SPOTIFY',
                  textAlign: TextAlign.center,
                  style: getMediumStyle(
                    color: ColorManager.white,
                    fontSize: FontSize.s32,
                  ),
                ),
                const SizedBox(height: AppSize.s20),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppPadding.p16),
                  child: Text(
                    'Instala a aplicação Spotify mais recente neste dispositivo antes de continuares com o passo seguinte:',
                    textAlign: TextAlign.center,
                    style: getMediumStyle(
                      color: ColorManager.white,
                      fontSize: FontSize.s14,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.p64),
              height: AppSize.s66,
              child: ElevatedButton(
                onPressed: () {
                  //
                },
                child: Text(
                  'Ligar com Spotify',
                  style: getMediumStyle(
                    color: Colors.black,
                    fontSize: FontSize.s16,
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
