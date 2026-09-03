import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

import '../../../app/di.dart';
import '../../../data/network/spotify_service.dart';
import '../../share/widgets/beatspan_loading_overlay.dart';

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

  static const _background = Color(0xFF08050D);
  static const _purple = Color(0xFF6C2BFF);
  static const _pink = Color(0xFFFF469E);

  @override
  void initState() {
    super.initState();
    _initSpotify();
  }

  @override
  void dispose() {
    SpotifySdk.pause().catchError((_) {});
    super.dispose();
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
      // A conexão com o Spotify App Remote normalmente já foi feita em
      // ConnectSpotifyPremiumView, mas a sessão pode ter caído (app em
      // background, timeout, etc.) até o usuário chegar nesta tela.
      // connectToSpotifyRemote é seguro chamar de novo se já conectado.
      final spotifyService = instance<SpotifyService>();
      await spotifyService.authorizeAndConnect();

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
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Stack(
          children: [
            // Ambient depth glows
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 300,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        _purple.withValues(alpha: 0.12),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 300,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        _pink.withValues(alpha: 0.12),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                    child: const Icon(Icons.close, color: Colors.white),
                  ),
                ),
              ),
            ),
            Center(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const BeatspanLoadingOverlay(
        message: 'CONECTANDO AO SPOTIFY...',
      );
    }

    if (_error != null || !_pluginAvailable || _playerStateStream == null) {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
            const SizedBox(height: 16),
            Text(
              _error ??
                  'Não foi possível inicializar o player do Spotify nesta plataforma.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Voltar'),
            ),
          ],
        ),
      );
    }

    return StreamBuilder<PlayerState>(
      stream: _playerStateStream,
      builder: (context, snap) {
        if (snap.hasError) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
              const SizedBox(height: 16),
              Text(
                'Erro na stream de estado do player:\n${snap.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          );
        }

        final playing = snap.data?.isPaused == false;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _VisualGlyphsCard(
              playing: playing,
              onTap: () => playing ? SpotifySdk.pause() : SpotifySdk.resume(),
            ),
            const SizedBox(height: 40),
            _nextCardButton(),
          ],
        );
      },
    );
  }

  Widget _nextCardButton() {
    return SizedBox(
      width: 280,
      height: 56,
      child: ElevatedButton(
        onPressed: () => Navigator.of(context).pop(),
        style: ElevatedButton.styleFrom(
          backgroundColor: _purple,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: 0,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'PRÓXIMA CARTA',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, size: 18),
          ],
        ),
      ),
    );
  }
}

class _VisualGlyphsCard extends StatefulWidget {
  final bool playing;
  final VoidCallback onTap;

  const _VisualGlyphsCard({required this.playing, required this.onTap});

  @override
  State<_VisualGlyphsCard> createState() => _VisualGlyphsCardState();
}

class _VisualGlyphsCardState extends State<_VisualGlyphsCard>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;

  static const _ringDurationsMs = [8000, 6000, 4000, 5000];
  static const _ringReversed = [false, true, false, true];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      _ringDurationsMs.length,
      (i) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: _ringDurationsMs[i]),
      )..repeat(reverse: false),
    );
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 320,
        height: 320,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white.withValues(alpha: 0.05),
          border: Border.all(
            color: const Color(0xFF6C2BFF).withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6C2BFF).withValues(alpha: 0.15),
              blurRadius: 40,
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: Listenable.merge(_controllers),
              builder: (context, _) {
                return CustomPaint(
                  size: const Size(320, 320),
                  painter: _GlyphRingsPainter(
                    turns: _controllers
                        .asMap()
                        .entries
                        .map(
                          (e) => _ringReversed[e.key]
                              ? -e.value.value
                              : e.value.value,
                        )
                        .toList(),
                  ),
                );
              },
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFF08050D).withValues(alpha: 0.3),
              ),
            ),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFF8F7FC),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.25),
                    blurRadius: 30,
                  ),
                ],
              ),
              child: Icon(
                widget.playing ? Icons.pause : Icons.play_arrow,
                color: const Color(0xFF08050D),
                size: 36,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlyphRingsPainter extends CustomPainter {
  final List<double> turns;

  _GlyphRingsPainter({required this.turns});

  static const _rings = [
    _RingSpec(radius: 110, strokeWidth: 6, dashes: [140, 50, 60, 40], opacity: 0.8),
    _RingSpec(radius: 90, strokeWidth: 6, dashes: [100, 40, 70, 30], opacity: 0.9),
    _RingSpec(radius: 70, strokeWidth: 5, dashes: [80, 30, 50, 40], opacity: 0.85),
    _RingSpec(radius: 50, strokeWidth: 4, dashes: [60, 25, 30, 20], opacity: 0.75),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    // O SVG original usa viewBox 200x200; escalamos proporcionalmente.
    final scale = size.width / 200;

    for (var i = 0; i < _rings.length; i++) {
      final ring = _rings[i];
      final gradientColors = [
        const Color(0xFF6C2BFF).withValues(alpha: ring.opacity),
        const Color(0xFFFF469E).withValues(alpha: ring.opacity),
      ];
      final paint = Paint()
        ..shader = LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(
          Rect.fromCircle(center: center, radius: ring.radius * scale),
        )
        ..style = PaintingStyle.stroke
        ..strokeWidth = ring.strokeWidth * scale
        ..strokeCap = StrokeCap.round;

      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(turns[i] * 2 * math.pi);
      canvas.translate(-center.dx, -center.dy);

      final path = _dashedCirclePath(
        center: center,
        radius: ring.radius * scale,
        dashes: ring.dashes.map((d) => d * scale).toList(),
      );
      canvas.drawPath(path, paint);
      canvas.restore();
    }
  }

  Path _dashedCirclePath({
    required Offset center,
    required double radius,
    required List<double> dashes,
  }) {
    final circumference = 2 * math.pi * radius;
    final path = Path();
    double distance = 0;
    var dashIndex = 0;
    var draw = true;

    while (distance < circumference) {
      final dashLength = dashes[dashIndex % dashes.length];
      final startAngle = (distance / circumference) * 2 * math.pi - math.pi / 2;
      final endAngle =
          ((distance + dashLength).clamp(0, circumference) / circumference) *
              2 *
              math.pi -
          math.pi / 2;

      if (draw) {
        path.addArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          endAngle - startAngle,
        );
      }

      distance += dashLength;
      dashIndex++;
      draw = !draw;
    }

    return path;
  }

  @override
  bool shouldRepaint(covariant _GlyphRingsPainter oldDelegate) => true;
}

class _RingSpec {
  final double radius;
  final double strokeWidth;
  final List<double> dashes;
  final double opacity;

  const _RingSpec({
    required this.radius,
    required this.strokeWidth,
    required this.dashes,
    required this.opacity,
  });
}
