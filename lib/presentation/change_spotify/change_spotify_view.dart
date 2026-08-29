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
import 'widgets/spotify_connect_graphic.dart';

class ChangeSpotifyView extends StatefulWidget {
  const ChangeSpotifyView({super.key});

  @override
  State<ChangeSpotifyView> createState() => _ChangeSpotifyViewState();
}

class _ChangeSpotifyViewState extends State<ChangeSpotifyView> {
  final AppPreferences _appPreferences = instance<AppPreferences>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(height: 8),
                  Text(
                    'CONEXÃO SPOTIFY PREMIUM',
                    style: TextStyle(fontSize: 16, color: Color(0XFFF8F7FC)),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Se você tem uma conta Spotify Premium, conecte o app ao Beatspan. Certifique-se de que o app está instalado no dispositivo.',
                    style: TextStyle(color: Color(0XB3F8F7FC)),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.center,
                child: SpotifyConnectGraphic(),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Container(
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6C2BFF), Color(0xFFFF469E)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(28),
                          onTap: () {
                            final NavigatorState navigator = Navigator.of(
                              context,
                            );
                            navigator.pushNamed(
                              Routes.changeSpotifyPremiumRoute,
                            );
                          },
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.graphic_eq),
                                SizedBox(width: 8),
                                Text(
                                  'LIGAR COM SPOTIFY',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(width: 2, color: Color(0XFFFFB0CB)),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(28),
                          onTap: () {
                            _appPreferences.setAppPlanType(PlanType.free);
                            Navigator.of(
                              context,
                            ).pushNamed(Routes.changeSpotifyFreeRoute);
                          },
                          child: Center(
                            child: Text(
                              'NÃO TENHO SPOTIFY PREMIUM',
                              style: TextStyle(
                                color: Color(0XFFFFB0CB),
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
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
      ),
    );
    // final args =
    // ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    // final from = args?['from'] as String?;
    // return ScaffoldHitster(
    //   sndRoute: '/close',
    //   bubbles: 3,
    //   colorFst: ColorManager.ternary,
    //   colorSnd: ColorManager.ternaryLight,
    //   child: Padding(
    //     padding: const EdgeInsets.only(
    //       top: AppPadding.p120,
    //       bottom: AppPadding.p120,
    //     ),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.stretch,
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: [
    //         Column(
    //           children: [
    //             Text(
    //               'SPOTIFY PREMIUM?',
    //               textAlign: TextAlign.center,
    //               style: getMediumStyle(
    //                 color: ColorManager.white,
    //                 fontSize: FontSize.s32,
    //               ),
    //             ),
    //             const SizedBox(height: AppSize.s20),
    //             Padding(
    //               padding: const EdgeInsets.symmetric(
    //                 horizontal: AppPadding.p16,
    //               ),
    //               child: Text(
    //                 'Escolhe o Spotify Free se não tiveres uma conta Spotify paga. Caso contrário, seleciona o Spotify Premium para obteres a melhor experiência. Visitar Spotify.com para mais informações.',
    //                 textAlign: TextAlign.center,
    //                 style: getMediumStyle(
    //                   color: ColorManager.white,
    //                   fontSize: FontSize.s14,
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //         Column(
    //           children: [
    //             SizedBox(
    //               height: AppSize.s66,
    //               width: AppSize.s220,
    //               child: ElevatedButton(
    //                 onPressed: () {
    //                   final NavigatorState navigator = Navigator.of(context);
    //                   _appPreferences.setAppPlanType(PlanType.free);
    //                   if (from == Routes.splashRoute) {
    //                     navigator.pushReplacementNamed(Routes.homeRoute);
    //                   } else {
    //                     navigator.pop();
    //                   }
    //                 },
    //                 child: Text(
    //                   'Spotify Free',
    //                   style: getMediumStyle(
    //                     color: Colors.black,
    //                     fontSize: FontSize.s16,
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             Padding(
    //               padding: const EdgeInsets.symmetric(vertical: AppPadding.p24),
    //               child: Text(
    //                 'OU',
    //                 style: getMediumStyle(
    //                   color: ColorManager.white,
    //                   fontSize: FontSize.s16,
    //                 ),
    //               ),
    //             ),
    //             SizedBox(
    //               height: AppSize.s66,
    //               width: AppSize.s220,
    //               child: ElevatedButton(
    // onPressed: () {
    //   final NavigatorState navigator = Navigator.of(context);
    //   navigator.pushNamed(Routes.changeSpotifyPremiumRoute);
    // },
    //                 child: Text(
    //                   'Spotify Premium',
    //                   style: getMediumStyle(
    //                     color: Colors.black,
    //                     fontSize: FontSize.s16,
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
