import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../resource/color_manager.dart';
import 'widget/scanner_overlay.dart';

class GameView extends StatefulWidget {
  const GameView({super.key});

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  final MobileScannerController controller = MobileScannerController();
  bool _isHandlingCode = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
              controller: controller,
              fit: BoxFit.cover,
              scanWindow: scanWindow,
              onDetect: (capture) {
                final barcode = capture.barcodes.first;
                final value = barcode.rawValue;
                if (value == null) return;
                debugPrint('QR lido: $value');
              },
            ),
          ),
          ScannerOverlay(),
        ],
      ),
    );
  }
}
