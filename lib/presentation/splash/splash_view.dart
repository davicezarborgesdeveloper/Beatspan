import 'package:flutter/material.dart';
import '../../app/app_prefs.dart';
import '../../app/di.dart';
import '../resource/assets_manager.dart';
import '../resource/screen_manager.dart';
import '../routes_manager.dart';
import 'widgets/loading_dots.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  final AppPreferences _appPreferences = instance<AppPreferences>();
  late final AnimationController _c;

  // Entrada
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<Offset> _nameOffset;
  late final Animation<double> _nameOpacity;
  late final Animation<Offset> _taglineOffset;
  late final Animation<double> _taglineOpacity;

  // Saída
  late final Animation<double> _dotsExitOpacity;
  late final Animation<double> _taglineExitOpacity;
  late final Animation<double> _nameExitOpacity;
  late final Animation<double> _logoExitScale;
  late final Animation<Offset> _logoExitOffset;

  static const totalMs = 3700;

  bool _didNavigate = false;

  void _goNext() async {
    final NavigatorState navigator = Navigator.of(context);

    if (_didNavigate || !mounted) return;
    _didNavigate = true;
    _appPreferences.getAppPlanType().then((plan) {
      if (plan != null) {
        navigator.pushReplacementNamed(Routes.homeRoute);
      } else {
        navigator.pushReplacementNamed(Routes.firstTimeRoute);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: totalMs),
    );

    // --- Entrada ---
    _logoScale = Tween(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _c,
        curve: const Interval(0.0, 0.19, curve: Curves.elasticOut),
      ),
    );
    _logoOpacity = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _c, curve: const Interval(0.0, 0.10)));

    _nameOffset = Tween(begin: const Offset(0, 0.15), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _c,
        curve: const Interval(0.135, 0.30, curve: Curves.easeOut),
      ),
    );
    _nameOpacity = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _c, curve: const Interval(0.135, 0.30)));

    _taglineOffset = Tween(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _c,
            curve: const Interval(0.216, 0.38, curve: Curves.easeOut),
          ),
        );
    _taglineOpacity = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _c, curve: const Interval(0.216, 0.38)));

    // --- Saída (cascata reversa) ---
    _dotsExitOpacity = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _c,
        curve: const Interval(0.54, 0.635, curve: Curves.easeIn),
      ),
    );
    _taglineExitOpacity = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _c,
        curve: const Interval(0.594, 0.689, curve: Curves.easeIn),
      ),
    );
    _nameExitOpacity = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _c,
        curve: const Interval(0.676, 0.770, curve: Curves.easeIn),
      ),
    );
    _logoExitScale = Tween(begin: 1.0, end: 0.4).animate(
      CurvedAnimation(
        parent: _c,
        curve: const Interval(0.865, 1.0, curve: Curves.easeIn),
      ),
    );
    _logoExitOffset = Tween(begin: Offset.zero, end: const Offset(0, -2.6))
        .animate(
          CurvedAnimation(
            parent: _c,
            curve: const Interval(0.865, 1.0, curve: Curves.easeIn),
          ),
        );

    _c.forward().whenComplete(_goNext);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF08050D),
      // floatingActionButton: Row(
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   children: [
      //     FloatingActionButton(
      //       heroTag: 'play',
      //       onPressed: () {
      //         _didNavigate = false;
      //         _c.reset();
      //         _c.forward().whenComplete(() {
      //           _goNext();
      //           _c.reset();
      //         });
      //       },
      //       child: const Icon(Icons.play_arrow),
      //     ),
      //     const SizedBox(width: 12),
      //     FloatingActionButton(
      //       heroTag: 'pauseMiddle',
      //       onPressed: () {
      //         _didNavigate =
      //             true; // segura a navegação enquanto paramos no meio
      //         _c.animateTo(_middleStage);
      //       },
      //       child: const Icon(Icons.pause),
      //     ),
      //   ],
      // ),
      body: AnimatedBuilder(
        animation: _c,
        builder: (context, _) {
          return Stack(
            // alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo (entrada + saída combinadas)
                    Transform.translate(
                      offset: _logoExitOffset.value * 100,
                      child: Transform.scale(
                        scale: _logoScale.value * _logoExitScale.value,
                        child: Opacity(
                          opacity: _logoOpacity.value,
                          child: SizedBox(
                            width: context.screenShortestSide * 0.476,
                            child: Image.asset(ImageAssets.splashLogo),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Opacity(
                      opacity: _nameOpacity.value * _nameExitOpacity.value,
                      child: Transform.translate(
                        offset: _nameOffset.value * 40,
                        child: SizedBox(
                          width: context.screenShortestSide * 0.78,
                          child: Image.asset(ImageAssets.splashWordmark),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Tagline
                    Opacity(
                      opacity:
                          _taglineOpacity.value * _taglineExitOpacity.value,
                      child: Transform.translate(
                        offset: _taglineOffset.value * 40,
                        child: ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [
                              Color(0xFF6C5CE7),
                              Color(0xFFE84BC7),
                              Color(0xFFFF8A3D),
                            ],
                          ).createShader(bounds),
                          child: const Text(
                            'MUSIC. FAITH. CONNECT.',
                            style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 3.5,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Dots (posicionados perto da base)
              Positioned(
                left: 0,
                right: 0,
                bottom: 120,
                child: Column(
                  children: [
                    Opacity(
                      opacity: _dotsExitOpacity.value,
                      child: LoadingDots(controller: _c),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'CARREGANDO...',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 4.0,
                        color: Color(0xFFA9A2B5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// class _LoadingDots extends StatefulWidget {
//   final AnimationController controller;
//   const _LoadingDots({required this.controller});

//   @override
//   State<_LoadingDots> createState() => _LoadingDotsState();
// }

// class _LoadingDotsState extends State<_LoadingDots>
//     with SingleTickerProviderStateMixin {
//   static const _dotCount = 5;
//   static const _dotColors = [
//     Color(0xFF6C5CE7),
//     Color(0xFF9C4FE0),
//     Color(0xFFE84BC7),
//     Color(0xFFFF6F5C),
//     Color(0xFFFF8A3D),
//   ];

//   late final AnimationController _loop;

//   @override
//   void initState() {
//     super.initState();
//     _loop = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1200),
//     )..repeat();
//   }

//   @override
//   void dispose() {
//     _loop.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: Listenable.merge([widget.controller, _loop]),
//       builder: (context, _) {
//         return Row(
//           mainAxisSize: MainAxisSize.min,
//           children: List.generate(_dotCount, (i) {
//             final delay = i / _dotCount;
//             final t = ((_loop.value - delay) % 1.0 + 1.0) % 1.0;
//             final pulse = Curves.easeInOut.transform(
//               t < 0.5 ? 1 - (t * 2) : (t - 0.5) * 2,
//             );
//             final color = Color.lerp(
//               Colors.grey.shade800,
//               _dotColors[i],
//               pulse,
//             );
//             return Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8),
//               child: Transform.scale(
//                 scale: 0.85 + (0.15 * pulse),
//                 child: Container(
//                   width: 12,
//                   height: 12,
//                   decoration: BoxDecoration(
//                     color: color,
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//               ),
//             );
//           }),
//         );
//       },
//     );
//   }
// }
