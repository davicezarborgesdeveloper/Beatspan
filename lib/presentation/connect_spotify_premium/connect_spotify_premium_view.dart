import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/di.dart';
import '../../data/network/spotify_service.dart';
import '../../domain/enum/flow_state.dart';
import '../resource/color_manager.dart';
import '../resource/font_manager.dart';
import '../resource/style_manager.dart';
import '../resource/value_manager.dart';
import '../share/widgets/scaffold_hitster.dart';
import 'connect_spotify_premium_view_model.dart';

class ConnectSpotifyPremiumView extends StatefulWidget {
  const ConnectSpotifyPremiumView({super.key});

  @override
  State<ConnectSpotifyPremiumView> createState() =>
      _ConnectSpotifyPremiumViewState();
}

class _ConnectSpotifyPremiumViewState extends State<ConnectSpotifyPremiumView> {
  final _viewModel = ConnectSpotifyPremiumViewModel(instance<SpotifyService>());

  @override
  void initState() {
    _bind();
    _viewModel.state.addListener(() {
      if (mounted && _viewModel.state.value == FlowState.error) {
        final message = _viewModel.errorMessage.value ?? 'Erro desconhecido';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              message,
              style: getMediumStyle(
                color: ColorManager.white,
                fontSize: FontSize.s14,
              ),
            ),
            backgroundColor: ColorManager.warning,
          ),
        );
      }
    });
    super.initState();
  }

  void _bind() {
    _viewModel.start();
  }

  @override
  Widget build(BuildContext context) {
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
                  'LIGAR COM SPOTIFY',
                  textAlign: TextAlign.center,
                  style: getMediumStyle(
                    color: ColorManager.white,
                    fontSize: FontSize.s32,
                  ),
                ),
                const SizedBox(height: AppSize.s20),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPadding.p16,
                  ),
                  child: Text(
                    'Instala a aplicação Spotify mais recente neste dispositivo antes de continuares com o passo seguinte:',
                    textAlign: TextAlign.center,
                    style: getMediumStyle(
                      color: ColorManager.white,
                      fontSize: FontSize.s14,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.p64),
              height: AppSize.s66,
              child: ElevatedButton(
                onPressed: () async {
                  _viewModel.connect();
                },
                child: Text(
                  'Ligar com Spotify',
                  style: getMediumStyle(
                    color: Colors.black,
                    fontSize: FontSize.s16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
