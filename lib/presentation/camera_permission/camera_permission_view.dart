import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../resource/color_manager.dart';

class CameraPermissionView extends StatelessWidget {
  const CameraPermissionView({super.key});

  Future<void> _requestPermission(BuildContext context) async {
    final status = await Permission.camera.request();
    if (!context.mounted) return;

    if (status.isGranted) {
      Navigator.of(context).pop(true);
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorManager.bagroundColor,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(false),
                  child: Icon(Icons.close, color: Colors.white, size: 28),
                ),
              ),
              Column(
                children: [
                  SizedBox(height: 48),
                  Text(
                    'BEATSPAN PRECISA ACESSAR\nSUA CÂMERA.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Color(0XFFF8F7FC),
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'O app BEATSPAN precisa acessar a câmera do dispositivo para escanear os QR codes das cartas.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0XB3F8F7FC)),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.center,
                child: _CameraGraphic(),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
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
                      onTap: () => _requestPermission(context),
                      child: Center(
                        child: Text(
                          'PERMITIR',
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CameraGraphic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 256,
      height: 256,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.002),
        shape: BoxShape.circle,
        border: Border.all(width: 2, color: Color(0XFFFF469E)),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFFF469E),
            blurRadius: 15,
            spreadRadius: 0,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0XFF110B1A),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.qr_code_2,
          size: 140,
          color: Color(0xFF2CCBF5),
        ),
      ),
    );
  }
}
