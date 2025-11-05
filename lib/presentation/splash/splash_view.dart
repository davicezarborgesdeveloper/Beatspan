import 'dart:async';

import 'package:flutter/material.dart';
import '../../app/app_prefs.dart';
import '../../app/di.dart';
import '../resource/color_manager.dart';
import '../resource/font_manager.dart';
import '../routes_manager.dart';
import '../resource/screen_manager.dart';
import '../resource/value_manager.dart';

import '../resource/assets_manager.dart';
import '../resource/style_manager.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  final AppPreferences _appPreferences = instance<AppPreferences>();
  static const durationTitle = Duration(milliseconds: 600);
  static const delayBetween = Duration(seconds: 1);
  static const durationSubtitle = Duration(milliseconds: 600);

  late final AnimationController _ctrlTitle;
  late final AnimationController _ctrlSubtitle;
  late final Animation<double> _opTitle;
  late final Animation<double> _opSubtitle;

  bool _didNavigate = false;

  void _goNext() async {
    final NavigatorState navigator = Navigator.of(context);

    if (_didNavigate || !mounted) return;
    _didNavigate = true;
    _appPreferences.getAppPlanType().then((plan) {
      if (plan != null) {
        navigator.pushReplacementNamed(Routes.homeRoute);
      } else {
        navigator.pushReplacementNamed(
          Routes.changeSpotifyRoute,
          arguments: {'from': Routes.splashRoute},
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _ctrlTitle = AnimationController(vsync: this, duration: durationTitle);
    _ctrlSubtitle =
        AnimationController(vsync: this, duration: durationSubtitle);

    _opTitle = CurvedAnimation(parent: _ctrlTitle, curve: Curves.easeOut);
    _opSubtitle = CurvedAnimation(parent: _ctrlSubtitle, curve: Curves.easeOut);

    _ctrlTitle.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(delayBetween, () {
          if (mounted) _ctrlSubtitle.forward();
        });
      }
    });

    _ctrlSubtitle.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(delayBetween, () {
          _goNext();
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ctrlTitle.forward();
    });
  }

  @override
  void dispose() {
    _ctrlTitle.dispose();
    _ctrlSubtitle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _opTitle,
              child: SizedBox(
                width: context.screenWidth - AppPadding.p46,
                child: Image.asset(
                  ImageAssets.logoSplash,
                ),
              ),
            ),
            FadeTransition(
              opacity: _opSubtitle,
              child: Column(
                children: [
                  const SizedBox(height: AppPadding.p24),
                  Text(
                    'The music party game',
                    textAlign: TextAlign.center,
                    style: getRegularStyle(
                      color: ColorManager.white,
                      fontSize: FontSize.s20,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
