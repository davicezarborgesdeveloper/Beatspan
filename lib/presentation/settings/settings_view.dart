import 'package:flutter/material.dart';

import '../resource/color_manager.dart';
import '../resource/font_manager.dart';
import '../resource/style_manager.dart';
import '../resource/value_manager.dart';
import '../routes_manager.dart';
import '../share/widgets/scaffold_hitster.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
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
            children: [
              SizedBox(height: 16),
              Text(
                'Geral',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0XFFA9A2B5),
                ),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: Color(0XFF110B1A),
                    border: Border.all(
                      width: 1,
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0)

                    )
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Como Jogar',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0XFFF8F7FC),
                        ),
                      ),
                      Icon(Icons.link,color: Color(0XFFF8F7FC),),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 4),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                   decoration: BoxDecoration(
                    color: Color(0XFF110B1A),
                    border: Border.all(
                      width: 1,
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12.0),
                      bottomRight: Radius.circular(12.0)

                    )
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Perguntas frequentes',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0XFFF8F7FC),
                        ),
                      ),
                      Icon(Icons.link,color: Color(0XFFF8F7FC),),
                    ],
                  ),
                ),
              ),
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
