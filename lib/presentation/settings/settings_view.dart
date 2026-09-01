import 'package:flutter/material.dart';

import '../../app/app_prefs.dart';
import '../../app/di.dart';
import '../../domain/enum/settings_enum.dart';
import '../change_spotify/connect_spotify_premium_view_model.dart';
import '../resource/color_manager.dart';
import '../resource/font_manager.dart';
import '../resource/style_manager.dart';
import '../resource/value_manager.dart';
import '../routes_manager.dart';
import '../share/widgets/scaffold_hitster.dart';
import 'widget/game_mode.dart';
import 'widget/general_settings.dart';
import 'widget/turn_phone.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final AppPreferences _appPreferences = instance<AppPreferences>();
  late final ConnectSpotifyPremiumViewModel _viewModel;
  PlanType? _planType;

  @override
  void initState() {
    super.initState();
    initSpotifyModule();
    _viewModel = instance<ConnectSpotifyPremiumViewModel>();
    _loadPlanType();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _loadPlanType() async {
    final plan = await _appPreferences.getAppPlanType();
    if (!mounted) return;
    setState(() => _planType = plan);
  }

  Future<void> _connectSpotify() async {
    await _viewModel.connect();
    await _loadPlanType();
  }

  @override
  Widget build(BuildContext context) {
    final isPremium = _planType == PlanType.premium;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0XFF08050D),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Configurações',
            style: TextStyle(
              color: Color(0XFFCDBDFF),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              GeneralSettings(),
              SizedBox(height: 32),
              Text(
                'Configurações do spotify',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0XFFA9A2B5),
                ),
              ),
              SizedBox(height: 12),
              GestureDetector(
                onTap: isPremium ? null : _connectSpotify,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: Color(0XFF110B1A),
                    border: Border.all(
                      width: 1,
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.music_note,
                            color: Color(0XFF1DB954),
                            size: 18,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Spotify',
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0XFF1DB954),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        isPremium ? 'PREMIUM' : 'FREE',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0XFF1DB954),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32),
              GameMode(
                isPremium: isPremium,
                onTap: (value) {
                  print('Game mode selected: $value');
                },
              ),
              SizedBox(height: 32),
              TurnPhone(),
            ],
          ),
        ),
      ),
    );
    // return ScaffoldHitster(
    //   colorFst: ColorManager.ternary,
    //   colorSnd: ColorManager.ternaryLight,
    //   bubbles: 3,
    //   sndRoute: '/close',
    //   child: Padding(
    //     padding:
    //         const EdgeInsets.only(top: AppPadding.p120, bottom: AppPadding.p64),
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: [
    //         Column(
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           children: [
    //             Padding(
    //               padding: const EdgeInsets.only(
    //                 bottom: AppPadding.p32,
    //               ),
    //               child: Text(
    //                 'SETTINGS',
    //                 style: getMediumStyle(
    //                   color: ColorManager.white,
    //                   fontSize: FontSize.s32,
    //                 ),
    //               ),
    //             ),
    //             Padding(
    //               padding:
    //                   const EdgeInsets.symmetric(horizontal: AppPadding.p46),
    //               child: Text(
    //                 'A aplicação HITSTER esta atualmente configurada para Spotify Premium.',
    //                 textAlign: TextAlign.center,
    //                 style: getMediumStyle(
    //                   color: ColorManager.white,
    //                   fontSize: FontSize.s14,
    //                 ),
    //               ),
    //             ),
    //             Container(
    //               margin: const EdgeInsets.only(top: AppMargin.m20),
    //               width: AppSize.s250,
    //               height: AppSize.s66,
    //               child: ElevatedButton(
    //                 style: ElevatedButton.styleFrom(
    //                   backgroundColor: ColorManager.white,
    //                   elevation: 0,
    //                 ),
    //                 onPressed: () {
    //                   Navigator.of(context)
    //                       .pushNamed(Routes.changeSpotifyRoute);
    //                 },
    //                 child: Text(
    //                   'Altere o modo Spotify',
    //                   style: getMediumStyle(
    //                     color: ColorManager.black,
    //                     fontSize: FontSize.s16,
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             Padding(
    //               padding: const EdgeInsets.fromLTRB(
    //                 AppPadding.p64,
    //                 AppPadding.p46,
    //                 AppPadding.p64,
    //                 AppPadding.p24,
    //               ),
    //               child: Text(
    //                 'Altere o seu país de residencia ou idioma:',
    //                 textAlign: TextAlign.center,
    //                 style: getRegularStyle(
    //                   color: ColorManager.white,
    //                   fontSize: FontSize.s16,
    //                 ),
    //               ),
    //             ),
    //             Container(
    //               margin: const EdgeInsets.only(bottom: AppPadding.p20),
    //               width: AppSize.s250,
    //               height: AppSize.s66,
    //               child: ElevatedButton(
    //                 style: ElevatedButton.styleFrom(
    //                   backgroundColor: Colors.transparent,
    //                   side: BorderSide(color: ColorManager.white, width: 2),
    //                   elevation: 0,
    //                 ),
    //                 onPressed: null,
    //                 // onPressed: () {
    //                 //   Navigator.of(context).pushNamed(Routes.countryRoute);
    //                 // },
    //                 child: Text(
    //                   'Altere o país',
    //                   style: getMediumStyle(
    //                     color: ColorManager.white,
    //                     fontSize: FontSize.s16,
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             SizedBox(
    //               width: AppSize.s250,
    //               height: AppSize.s66,
    //               child: ElevatedButton(
    //                 style: ElevatedButton.styleFrom(
    //                   backgroundColor: Colors.transparent,
    //                   side: BorderSide(color: ColorManager.white, width: 2),
    //                   elevation: 0,
    //                 ),
    //                 onPressed: null,
    //                 // onPressed: () {
    //                 //   Navigator.of(context).pushNamed(Routes.languageRoute);
    //                 // },
    //                 child: Text(
    //                   'Altere o idioma',
    //                   style: getMediumStyle(
    //                     color: ColorManager.white,
    //                     fontSize: FontSize.s16,
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //         Text(
    //           'Versão 1.0.0',
    //           style: getMediumStyle(
    //             color: ColorManager.white,
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
