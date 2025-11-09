import 'package:flutter/material.dart';

import '../resource/assets_manager.dart';
import '../resource/color_manager.dart';
import '../resource/font_manager.dart';
import '../resource/screen_manager.dart';
import '../resource/style_manager.dart';
import '../resource/value_manager.dart';

class RulesView extends StatefulWidget {
  const RulesView({super.key});

  @override
  State<RulesView> createState() => _RulesViewState();
}

class _RulesViewState extends State<RulesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: ColorManager.white),
        backgroundColor: ColorManager.black,
        titleSpacing: 0,
        leadingWidth: 40,
        title: SizedBox(
          width: context.percentWidth(.3),
          child: Image.asset(ImageAssets.logoSplash),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: context.screenWidth / 1.5,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ImageAssets.rulesImage),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'COMO JOGAR',
                      style: getSemiBoldStyle(
                        color: ColorManager.white,
                        fontSize: FontSize.s32,
                      ),
                    ),
                    const SizedBox(height: AppPadding.p16),
                    Text(
                      'Hitster Original',
                      style: getRegularStyle(
                        color: ColorManager.white,
                        fontSize: FontSize.s20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Column(children: []),
          ],
        ),
      ),
    );
  }
}
