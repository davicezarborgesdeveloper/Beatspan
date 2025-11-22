import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../app/app_prefs.dart';
import '../../app/di.dart';
import '../../data/network/spotify_service.dart';
import '../../data/network/spotify_webapi.dart';
import '../../domain/enum/settings_enum.dart';
import 'game_viewmodel.dart';
import 'game_error_view.dart';
// import 'player_music/play_music_free_view.dart';
import 'player_music/player_music_premium_view.dart';
import 'widget/scanner_overlay.dart';

class GameView extends StatefulWidget {
  const GameView({super.key});

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  final MobileScannerController qrController = MobileScannerController();
  final GameViewModel controller = GameViewModel();
  final AppPreferences _appPreferences = instance<AppPreferences>();

  bool _isHandlingCode = false;

  @override
  void dispose() {
    qrController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) async {
    if (_isHandlingCode) return;

    final barcode = capture.barcodes.first;
    final value = barcode.rawValue;
    if (value == null) return;

    _isHandlingCode = true;

    // final navigator = Navigator.of(context);
    // await qrController.stop();
    if (!mounted) return;

    try {
      final result = controller.validate(value);

      if (result == QrValidationResult.invalid) {
        await _goToError();
        return;
      }

      await _handleSpotifyTrack(value);
    } finally {
      if (!mounted) return;
      _isHandlingCode = false;
      // await qrController.start();
    }
  }

  Future<void> _handleSpotifyTrack(String rawUrl) async {
    final spotifyUri = controller.toSpotifyUri(rawUrl);
    if (spotifyUri == null) {
      await _goToError();
      return;
    }
    final plan = await _appPreferences.getAppPlanType();
    if (plan == null) return;
    switch (plan) {
      case PlanType.premium:
        if (!mounted) return;
        await _navigateTo(PlayerMusicPremiumView(initialUri: spotifyUri));
        break;
      case PlanType.free:
        final trackId = controller.extractTrackId(rawUrl);
        if (trackId == null) {
          await _goToError();
          return;
        }
        final spotifyService = instance<SpotifyService>();
        final token = await spotifyService.getAccessToken();
        final api = SpotifyWebApi(token);
        final previewUrl = await api.getTrackPreviewUrl(trackId);

        if (previewUrl == null) {
          await _goToError();
          return;
        }

        if (!mounted) return;
        // await _navigateTo(PlayerMusicFreeView(previewUrl: previewUrl));
        break;
    }
  }

  Future<void> _goToError() async {
    if (!mounted) return;
    await _navigateTo(const GameErrorView());
  }

  Future<void> _navigateTo(Widget page) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final scanWindow = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: 260,
      height: 260,
    );

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: MobileScanner(
              controller: qrController,
              fit: BoxFit.cover,
              scanWindow: scanWindow,
              onDetect: _onDetect,
            ),
          ),
          ScannerOverlay(),
        ],
      ),
    );
  }
}
