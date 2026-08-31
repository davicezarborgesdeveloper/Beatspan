import 'package:flutter/material.dart';

import '../resource/assets_manager.dart';
import '../resource/color_manager.dart';
import '../routes_manager.dart';

class SpotifyFreeTransition extends StatelessWidget {
  const SpotifyFreeTransition({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorManager.bagroundColor,
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Padding(
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
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(height: 8),
                  Text(
                    'BEATSPAN SEM SPOTIFY PREMIYM',
                    style: TextStyle(fontSize: 16, color: Color(0XFFF8F7FC)),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Você pode jogar Beatspan sem Spotify Premium. Após escanear uma carta, vire o telefone para ouvir um preview de 30s.',
                    style: TextStyle(color: Color(0XB3F8F7FC)),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.center,
                child: Image.asset(ImageAssets.turnThePhone),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                            Navigator.of(
                              context,
                            ).pushReplacementNamed(Routes.homeRoute);
                          },
                          child: Center(
                            child: Text(
                              'CONTINUAR',
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
                            Navigator.of(context).pushNamed(Routes.rulesRoute);
                          },
                          child: Center(
                            child: Text(
                              'LER AS REGRAS',
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
  }
}
