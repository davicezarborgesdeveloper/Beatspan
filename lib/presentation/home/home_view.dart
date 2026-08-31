import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import '../camera_permission/camera_permission_view.dart';
import '../resource/color_manager.dart';
import '../resource/screen_manager.dart';
import '../routes_manager.dart';

import '../resource/assets_manager.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  DateTime? _lastPressedAt;
  void _handleBackPress() {
    final now = DateTime.now();
    if (_lastPressedAt == null ||
        now.difference(_lastPressedAt!) > const Duration(seconds: 3)) {
      // Primeira pressão ou passou 3 segundos
      _lastPressedAt = now;
      Fluttertoast.showToast(
        msg: 'Pressione novamente para sair',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2, // tempo de exibição (segundos) – opcional
        backgroundColor: Colors.grey[800],
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      exit(1);
    }
  }

  Future<void> _onPlayNow() async {
    final status = await Permission.camera.status;

    if (status.isGranted) {
      if (!mounted) return;
      Navigator.of(context).pushNamed(Routes.gameRoute);
      return;
    }

    if (!mounted) return;
    final granted = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const CameraPermissionView()),
    );

    if (granted == true && mounted) {
      Navigator.of(context).pushNamed(Routes.gameRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            _handleBackPress();
          }
        },
        child: Scaffold(
          backgroundColor: ColorManager.bagroundColor,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              children: [
                Column(
                  children: [
                    SizedBox(height: 16),
                    SizedBox(
                      height: 40,
                      child: Image.asset(ImageAssets.splashWordmark),
                    ),
                    SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(width: 1, color: Color(0X4DFFB0CB)),
                      ),
                      child: Text(
                        'O JOGO DA FESTA DA MÚSICA',
                        style: TextStyle(
                          color: Color(0XFFFFB0CB),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: context.percentWidth(0.8),
                    child: Image.asset(ImageAssets.laoudspeaker),
                  ),
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
                            colors: [Color(0xFF6C2BFF), Color(0xFFFF7A1A)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(28),
                            onTap: _onPlayNow,
                            child: Center(
                              child:Text(
                                    'JOGAR AGORA',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            width: 2,
                            color: Color(0X80FFB0CB),
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(28),
                            onTap: () {
                              Navigator.of(
                                context,
                              ).pushNamed(Routes.changeSpotifyFreeRoute);
                            },
                            child: Center(
                              child: Text(
                                'REGRAS E CONFIGURAÇÕES',
                                style: TextStyle(
                                  color: Color(0XFFFFB0CB),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
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
        // child: ScaffoldHitster(
        //   colorFst: ColorManager.primary,
        //   colorSnd: ColorManager.secondary,
        //   bubbles: 2,
        //   sndRoute: '/settings',
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Padding(
        //         padding: const EdgeInsets.only(top: 130),
        //         child: Column(
        //           children: [
        //             Text(
        //               'VAMOS JOGAR',
        //               style: getMediumStyle(
        //                 color: ColorManager.white,
        //                 fontSize: FontSize.s32,
        //               ),
        //             ),
        //             const SizedBox(height: AppPadding.p32),
        //             Image.asset(ImageAssets.splashWordmark),
        //             const SizedBox(height: AppPadding.p24),
        //             Text(
        //               'O jogo de cartas de música',
        //               style: getMediumStyle(
        //                 color: ColorManager.white,
        //                 fontSize: FontSize.s16,
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //       Padding(
        //         padding: const EdgeInsets.only(bottom: AppPadding.p80),
        //         child: Column(
        //           children: [
        //             SizedBox(
        //               height: AppSize.s66,
        //               width: AppSize.s220,
        //               child: ElevatedButton(
        //                 style: ElevatedButton.styleFrom(
        //                   backgroundColor: Colors.transparent,
        //                   side: BorderSide(color: ColorManager.white, width: 2),
        //                   elevation: 0,
        //                 ),
        //                 onPressed: () {
        //                   Navigator.of(context).push(
        //                     MaterialPageRoute(builder: (_) => const RulesView()),
        //                   );
        //                 },
        //                 child: Text(
        //                   'Ler as regras',
        //                   style: getMediumStyle(
        //                     color: ColorManager.white,
        //                     fontSize: FontSize.s16,
        //                   ),
        //                 ),
        //               ),
        //             ),
        //             Padding(
        //               padding: const EdgeInsets.symmetric(
        //                 vertical: AppPadding.p24,
        //               ),
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
        //                 onPressed: () {
        //                   Navigator.of(
        //                     context,
        //                   ).push(MaterialPageRoute(builder: (_) => GameView()));
        //                 },
        //                 child: Text(
        //                   'Começar um jogo',
        //                   style: getMediumStyle(
        //                     color: Colors.black,
        //                     fontSize: FontSize.s16,
        //                   ),
        //                 ),
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        //
      ),
    );
  }
}
