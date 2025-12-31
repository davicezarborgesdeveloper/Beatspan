import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class PlayerMusicPremiumView extends StatefulWidget {
  final String initialUri;

  const PlayerMusicPremiumView({super.key, required this.initialUri});

  @override
  State<PlayerMusicPremiumView> createState() => _PlayerMusicPremiumViewState();
}

class _PlayerMusicPremiumViewState extends State<PlayerMusicPremiumView> {
  bool _loading = true;
  String? _error;
  bool _pluginAvailable = true;

  Stream<PlayerState>? _playerStateStream;

  @override
  void initState() {
    super.initState();
    _initSpotify();
  }

  Future<void> _initSpotify() async {
    // Evita chamar o plugin em plataformas não suportadas
    if (!(kIsWeb || Platform.isAndroid || Platform.isIOS)) {
      setState(() {
        _pluginAvailable = false;
        _loading = false;
        _error = 'Plataforma não suportada pelo spotify_sdk.';
      });
      return;
    }

    try {
      // IMPORTANTE: conectar antes de tocar / assinar streams
      // Se você já faz isso em outro lugar (ex: ConnectSpotifyPremiumView),
      // pode pular essa parte ou checar conexão antes de conectar de novo.

      // Carrega credenciais do arquivo .env
      final clientId = dotenv.env['SPOTIFY_CLIENT_ID'];
      final redirectUrl = dotenv.env['SPOTIFY_REDIRECT_URL'];

      if (clientId == null || redirectUrl == null) {
        throw Exception(
          'SPOTIFY_CLIENT_ID e SPOTIFY_REDIRECT_URL não encontrados no .env',
        );
      }

      await SpotifySdk.connectToSpotifyRemote(
        clientId: clientId,
        redirectUrl: redirectUrl,
      );

      await SpotifySdk.play(spotifyUri: widget.initialUri);

      // prepara a stream de estado do player
      _playerStateStream = SpotifySdk.subscribePlayerState();

      setState(() {
        _loading = false;
      });
    } on MissingPluginException catch (e) {
      // Aqui é exatamente o erro que você está vendo
      setState(() {
        _pluginAvailable = false;
        _loading = false;
        _error =
            'Plugin spotify_sdk não foi encontrado/registrado para este engine.\n$e';
      });
    } on PlatformException catch (e) {
      setState(() {
        _loading = false;
        _error =
            'Erro de plataforma ao conectar/tocar no Spotify: ${e.message}';
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = 'Erro inesperado ao inicializar o player: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null || !_pluginAvailable || _playerStateStream == null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  _error ??
                      'Não foi possível inicializar o player do Spotify nesta plataforma.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Voltar'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: StreamBuilder<PlayerState>(
          stream: _playerStateStream,
          builder: (context, snap) {
            if (snap.hasError) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Erro na stream de estado do player:\n${snap.error}',
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            }

            final playing = snap.data?.isPaused == false;

            return GestureDetector(
              onTap: () => playing ? SpotifySdk.pause() : SpotifySdk.resume(),
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7BE495), Color(0xFF5EC5FF)],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  boxShadow: const [
                    BoxShadow(blurRadius: 24, color: Colors.black26),
                  ],
                ),
                child: Icon(
                  playing ? Icons.pause : Icons.play_arrow,
                  size: 120,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
