import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../resource/assets_manager.dart';
import '../resource/color_manager.dart';
import '../resource/screen_manager.dart';
import '../routes_manager.dart';

class FirstTimeView extends StatefulWidget {
  const FirstTimeView({super.key});

  @override
  State<FirstTimeView> createState() => _FirstTimeViewState();
}

class _FirstTimeViewState extends State<FirstTimeView> {
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
          appBar: AppBar(
            backgroundColor: ColorManager.bagroundColor,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: SizedBox(
              width: context.percentWidth(0.6),
              child: Image.asset(ImageAssets.splashWordmark),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                SizedBox(height: 28),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    'PRIMEIRA VEZ JOGANDO BEATSPAN?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 28,
                      color: Color(0xFFF8F7FC),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Comece lendo as regras - depois você estará pronto para escanear sua primeira carta!',
                  textAlign: TextAlign.center,

                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                    color: Color(0xFFF8F7FC),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1 / 2,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              width: 1,
                              color: Color(0X33FFB0CB),
                            ),
                            color: Color(0XFF110B1A),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x80000000),
                                offset: Offset(0, 4),
                                blurRadius: 30,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              '1983',
                              style: TextStyle(
                                color: Color(0XFFFFB0CB),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1 / 2,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              width: 1,
                              color: Color(0X33FFB0CB),
                            ),
                            color: Color(0XFF110B1A),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x80000000),
                                offset: Offset(0, 4),
                                blurRadius: 30,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              '2009',
                              style: TextStyle(
                                color: Color(0XFFFFB0CB),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Container(
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6C2BFF), Color(0xFFFF469E)],
                      stops: [0.0,100],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(28),
                      onTap: () {
                        Navigator.of(context).pushNamed(Routes.rulesRoute);
                      },
                      child: Center(
                        child: Text(
                          'LER AS REGRAS',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
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
                        Navigator.of(
                          context,
                        ).pushNamed(Routes.changeSpotifyRoute);
                      },
                      child: Center(
                        child: Text(
                          'CONTINUAR',
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
        ),
      ),
    );
  }
}
