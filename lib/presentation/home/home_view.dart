import 'package:flutter/material.dart';
import '../game/game_view.dart';
import '../resource/color_manager.dart';
import '../resource/font_manager.dart';
import '../rules/rules_view.dart';
import '../share/widgets/scaffold_hitster.dart';

import '../resource/assets_manager.dart';
import '../resource/style_manager.dart';
import '../resource/value_manager.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: ScaffoldHitster(
        colorFst: ColorManager.primary,
        colorSnd: ColorManager.secondary,
        bubbles: 2,
        sndRoute: '/settings',
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 130,
              ),
              child: Column(
                children: [
                  Text(
                    'VAMOS JOGAR',
                    style: getMediumStyle(
                      color: ColorManager.white,
                      fontSize: FontSize.s32,
                    ),
                  ),
                  const SizedBox(height: AppPadding.p32),
                  Image.asset(ImageAssets.logoSplash),
                  const SizedBox(height: AppPadding.p24),
                  Text(
                    'O jogo de cartas de música',
                    style: getMediumStyle(
                      color: ColorManager.white,
                      fontSize: FontSize.s16,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: AppPadding.p80,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: AppSize.s66,
                    width: AppSize.s220,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        side: BorderSide(color: ColorManager.white, width: 2),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const RulesView(),
                          ),
                        );
                      },
                      child: Text(
                        'Ler as regras',
                        style: getMediumStyle(
                          color: ColorManager.white,
                          fontSize: FontSize.s16,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: AppPadding.p24),
                    child: Text(
                      'OU',
                      style: getMediumStyle(
                        color: ColorManager.white,
                        fontSize: FontSize.s16,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: AppSize.s66,
                    width: AppSize.s220,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const GameView(),
                          ),
                        );
                      },
                      child: Text(
                        'Começar um jogo',
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
          ],
        ),
      ),
      //
    );
  }
}
