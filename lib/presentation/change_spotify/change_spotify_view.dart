import 'package:flutter/material.dart';

import '../../app/di.dart';
import '../../domain/enum/flow_state.dart';
import '../resource/color_manager.dart';
import '../resource/font_manager.dart';
import '../resource/style_manager.dart';
import '../routes_manager.dart';
import 'connect_spotify_premium_view_model.dart';
import 'widgets/spotify_connect_graphic.dart';

class ChangeSpotifyView extends StatefulWidget {
  const ChangeSpotifyView({super.key});

  @override
  State<ChangeSpotifyView> createState() => _ChangeSpotifyViewState();
}

class _ChangeSpotifyViewState extends State<ChangeSpotifyView> {
  late final ConnectSpotifyPremiumViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    initSpotifyModule();
    _viewModel = instance<ConnectSpotifyPremiumViewModel>();
    _viewModel.state.addListener(() {
      if (mounted) {
        if (_viewModel.state.value == FlowState.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _viewModel.errorMessage.value ?? 'Erro desconhecido',
                style: getMediumStyle(
                  color: ColorManager.white,
                  fontSize: FontSize.s14,
                ),
              ),
              backgroundColor: ColorManager.warning,
            ),
          );
        } else if (_viewModel.state.value == FlowState.success) {
          Navigator.of(context).pushReplacementNamed(Routes.homeRoute);
        }
      }
    });
  }

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
                          onTap: () async {
                            await _viewModel.connect();
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
                        border: Border.all(width: 2, color: Color(0XFF6824FC),),
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
                              'NÃO TENHO SPOTIFY PREMIUM',
                              style: TextStyle(
                                color: Color(0XFF6824FC),
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
