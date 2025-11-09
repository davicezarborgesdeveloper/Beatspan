import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/app_prefs.dart';
import '../../app/di.dart';
import '../../data/network/spotify_service.dart';
import '../../domain/enum/flow_state.dart';
import '../../domain/enum/settings_enum.dart';

class ConnectSpotifyPremiumViewModel {
  final SpotifyService _spotify;
  ConnectSpotifyPremiumViewModel(this._spotify);

  final state = ValueNotifier(FlowState.content);
  final isConnected = ValueNotifier<bool>(false);
  final errorMessage = ValueNotifier<String?>(null);

  final AppPreferences _appPreferences = instance<AppPreferences>();

  void start() {
    state.value = FlowState.content;
  }

  void dispose() {
    state.dispose();
    isConnected.dispose();
    errorMessage.dispose();
  }

  bool get _isSupportedPlatform =>
      !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  Future<void> connect() async {
    state.value = FlowState.loading;
    errorMessage.value = null;

    if (!_isSupportedPlatform) {
      state.value = FlowState.error;
      errorMessage.value = 'Spotify SDK só funciona em Android/iOS nativos.';
      return;
    }

    try {
      final token = await _spotify.getAccessToken();
      final connected = await _spotify.connect(accessToken: token);

      isConnected.value = connected;
      state.value = connected ? FlowState.success : FlowState.error;

      if (!connected) {
        errorMessage.value = 'Não foi possível conectar ao Spotify Remote.';
        state.value = FlowState.error;
      }

      _appPreferences.setAppPlanType(PlanType.premium);
    } on MissingPluginException catch (_) {
      state.value = FlowState.error;
      errorMessage.value =
          'Plugin não registrado no lado nativo (build desatualizado).';
    } on PlatformException catch (e) {
      _handlePlatformException(e);
    } catch (e) {
      state.value = FlowState.error;
      errorMessage.value = 'Erro inesperado: $e';
    }
  }

  Future<void> disconnect() async {
    try {
      await _spotify.disconnect();
      isConnected.value = false;
    } catch (_) {
      // silencioso
    }
  }

  void _handlePlatformException(PlatformException e) {
    state.value = FlowState.error;
    isConnected.value = false;
    print('------:${e.code}');
    switch (e.code) {
      case 'CouldNotFindSpotifyApp':
        final url = Platform.isIOS
            ? Uri.parse(
                'https://apps.apple.com/app/spotify-music-and-podcasts/id324684580',
              )
            : Uri.parse(
                'https://play.google.com/store/apps/details?id=com.spotify.music',
              );
        errorMessage.value =
            'App do Spotify não encontrado! Instale o app do Spotify e tente novamente.';
        launchUrl(url);

        break;
      case 'UserNotAuthorizedException':
        errorMessage.value =
            'Autorização negada/cancelada pelo usuário! Permita o acesso do Spotify para continuar.';

        break;
      default:
        final fallback = Uri.parse(
          'https://accounts.spotify.com/pt-BR/v2/login?continue=https%3A%2F%2Fwww.spotify.com%2Fbr-pt%2Faccount%2Foverview%2F',
        );
        errorMessage.value = '(${e.code})! Tente novamente após login.';
        launchUrl(fallback);
    }
  }
}
