import 'package:flutter/material.dart';

class ScannerOverlay extends StatelessWidget {
  const ScannerOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: Colors.black.withValues(alpha: 0.35)),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _roundIcon(
                  icon: Icons.help_outline,
                  onTap: () {
                    // abrir ajuda
                  },
                ),
                _roundIcon(
                  icon: Icons.close,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'Digitaliza o código QR na parte de trás da carta:',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: 260,
                height: 260,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _squared(),

                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _squared() {
    return SizedBox(
      width: 260,
      height: 260,
      child: Stack(
        children: [
          // canto superior esquerdo
          Positioned(
            top: 0,
            left: 0,
            child: SizedBox(
              width: 40,
              height: 40,
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.white, width: 4),
                    left: BorderSide(color: Colors.white, width: 4),
                  ),
                ),
              ),
            ),
          ),

          // canto superior direito
          Positioned(
            top: 0,
            right: 0,
            child: SizedBox(
              width: 40,
              height: 40,
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.white, width: 4),
                    right: BorderSide(color: Colors.white, width: 4),
                  ),
                ),
              ),
            ),
          ),

          // canto inferior esquerdo
          Positioned(
            bottom: 0,
            left: 0,
            child: SizedBox(
              width: 40,
              height: 40,
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.white, width: 4),
                    left: BorderSide(color: Colors.white, width: 4),
                  ),
                ),
              ),
            ),
          ),

          // canto inferior direito
          Positioned(
            bottom: 0,
            right: 0,
            child: SizedBox(
              width: 40,
              height: 40,
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.white, width: 4),
                    right: BorderSide(color: Colors.white, width: 4),
                  ),
                ),
              ),
            ),
          ),

          // bolinha com ícone de play (só visual)
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _roundIcon({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withValues(alpha: 0.5),
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
