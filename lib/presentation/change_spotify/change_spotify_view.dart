import 'package:flutter/material.dart';

import '../../app/app_prefs.dart';
import '../../app/di.dart';
import '../../domain/enum/settings_enum.dart';
import '../resource/color_manager.dart';
import '../resource/font_manager.dart';
import '../resource/style_manager.dart';
import '../resource/value_manager.dart';
import '../routes_manager.dart';
import '../share/widgets/scaffold_hitster.dart';

class ChangeSpotifyView extends StatefulWidget {
  const ChangeSpotifyView({super.key});

  @override
  State<ChangeSpotifyView> createState() => _ChangeSpotifyViewState();
}

class _ChangeSpotifyViewState extends State<ChangeSpotifyView> {
  final AppPreferences _appPreferences = instance<AppPreferences>();
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final from = args?['from'] as String?;
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
                  'SPOTIFY PREMIUM?',
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
                    'Escolhe o Spotify Free se não tiveres uma conta Spotify paga. Caso contrário, seleciona o Spotify Premium para obteres a melhor experiência. Visitar Spotify.com para mais informações.',
                    textAlign: TextAlign.center,
                    style: getMediumStyle(
                      color: ColorManager.white,
                      fontSize: FontSize.s14,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(
                  height: AppSize.s66,
                  width: AppSize.s220,
                  child: ElevatedButton(
                    onPressed: () {
                      final NavigatorState navigator = Navigator.of(context);
                      _appPreferences.setAppPlanType(PlanType.free);
                      if (from == Routes.splashRoute) {
                        navigator.pushReplacementNamed(Routes.homeRoute);
                      } else {
                        navigator.pop();
                      }
                    },
                    child: Text(
                      'Spotify Free',
                      style: getMediumStyle(
                        color: Colors.black,
                        fontSize: FontSize.s16,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppPadding.p24),
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
                      final NavigatorState navigator = Navigator.of(context);
                      _appPreferences.setAppPlanType(PlanType.premium);
                      navigator.pushNamed(Routes.changeSpotifyPremiumRoute);

                      // _appPreferences.setAppPlanType(PlanType.free);
                      // if (from == Routes.splashRoute) {
                      //   navigator.pushReplacementNamed(Routes.homeRoute);
                      // } else {
                      //   navigator.pop();
                      // }
                    },
                    child: Text(
                      'Spotify Premium',
                      style: getMediumStyle(
                        color: Colors.black,
                        fontSize: FontSize.s16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
