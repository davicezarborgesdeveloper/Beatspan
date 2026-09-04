import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../../app/di.dart';
import '../../../data/network/spotify_service.dart';
import '../../../data/network/spotify_webapi.dart';
import '../../share/widgets/beatspan_loading_overlay.dart';

class PlayerMusicFreeView extends StatefulWidget {
  final String? trackId; // ID da faixa no Spotify
  final String previewUrl; // URL de 30s
  final String? trackName;
  final String? artistName;
  final String? albumArtUrl;

  const PlayerMusicFreeView({
    super.key,
    this.trackId,
    required this.previewUrl,
    this.trackName,
    this.artistName,
    this.albumArtUrl,
  });

  @override
  State<PlayerMusicFreeView> createState() => _PlayerMusicFreeViewState();
}

class _PlayerMusicFreeViewState extends State<PlayerMusicFreeView> {
  final AudioPlayer _player = AudioPlayer();

  bool _isLoading = true;
  String? _error;

  bool _isSavingTrack = false;
  bool _isTrackSaved = false;

  static const _purple = Color(0xFF6C2BFF);
  static const _pink = Color(0xFFE84BC7);
  static const _cyan = Color(0xFF2CCBF5);

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    try {
      await _player.setUrl(widget.previewUrl);
      setState(() => _isLoading = false);
      _player.play(); // começa a tocar automaticamente
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Não foi possível carregar a prévia de 30 segundos.';
      });
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _saveToSpotify() async {
    final trackId = widget.trackId;
    if (trackId == null || _isSavingTrack || _isTrackSaved) return;

    setState(() => _isSavingTrack = true);
    try {
      final spotifyService = instance<SpotifyService>();
      final token = await spotifyService.getAccessToken();
      final api = SpotifyWebApi(token);
      final saved = await api.saveTrack(trackId);

      if (!mounted) return;
      setState(() => _isTrackSaved = saved);

      if (!saved) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Não foi possível salvar a faixa no Spotify.'),
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível salvar a faixa no Spotify.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSavingTrack = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF08050D),
      body: SafeArea(
        child: _isLoading
            ? const BeatspanLoadingOverlay(
                message: 'CARREGANDO PRÉVIA...',
                fillBackground: true,
              )
            : _error != null
            ? _buildError(_error!)
            : _buildPlayer(),
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayer() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.08),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                ),
                child: const Icon(Icons.close, color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Color(0XFF110B1A),
              border: Border.all(
                width: 1,
                color: Colors.white.withValues(alpha: 0.05),
              ),
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 40,
                  spreadRadius: 0,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _albumArt(),
                SizedBox(height: 24),
                Text(
                  widget.trackName ?? '',
                  style: TextStyle(fontSize: 16, color: Color(0XFFF8F7FC)),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      widget.artistName ?? '',
                      style: TextStyle(fontSize: 18, color: Color(0XFFA9A2B5)),
                    ),
                    SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0XFF06B6D4).withValues(alpha: 0.1),
                        border: Border.all(
                          color: Color(0XFF06B6D4).withValues(alpha: 0.2),
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'PRÉVIA',
                        style: TextStyle(
                          color: Color(0XFF06B6D4),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                _playButton(),
              ],
            ),
          ),
          SizedBox(height: 32),
          _nextCardButton(),
        ],
      ),
    );
  }

  // Widget _buildPlayer() {
  //   return Padding(
  //     padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
  //     child: Column(
  //       children: [
  // Align(
  //   alignment: Alignment.topRight,
  //   child: GestureDetector(
  //     onTap: () => Navigator.of(context).pop(),
  //     child: Container(
  //       width: 44,
  //       height: 44,
  //       decoration: BoxDecoration(
  //         shape: BoxShape.circle,
  //         color: Colors.white.withValues(alpha: 0.08),
  //         border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
  //       ),
  //       child: const Icon(Icons.close, color: Colors.white),
  //     ),
  //   ),
  // ),
  //         const Spacer(),
  //         _albumArt(),
  //         const SizedBox(height: 32),
  //         Text(
  //           widget.trackName ?? 'Faixa desconhecida',
  //           textAlign: TextAlign.center,
  //           style: const TextStyle(
  //             color: Colors.white,
  //             fontSize: 22,
  //             fontWeight: FontWeight.w800,
  //           ),
  //         ),
  //         const SizedBox(height: 8),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Flexible(
  //               child: Text(
  //                 widget.artistName ?? '',
  //                 textAlign: TextAlign.center,
  //                 overflow: TextOverflow.ellipsis,
  //                 style: TextStyle(
  //                   color: Colors.white.withValues(alpha: 0.7),
  //                   fontSize: 16,
  //                 ),
  //               ),
  //             ),
  //             if (widget.artistName != null) ...[
  //               const SizedBox(width: 8),
  //               _previaBadge(),
  //             ],
  //           ],
  //         ),
  //         const Spacer(),
  //         _playButton(),
  //         const SizedBox(height: 32),
  //         _nextCardButton(),
  //       ],
  //     ),
  //   );
  // }

  Widget _previaBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _cyan),
      ),
      child: const Text(
        'PRÉVIA',
        style: TextStyle(
          color: _cyan,
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _albumArt() {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: widget.albumArtUrl != null
          ? Image.network(
              widget.albumArtUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _albumArtFallback(),
            )
          : _albumArtFallback(),
    );
  }

  Widget _albumArtFallback() {
    return const Center(
      child: Icon(Icons.music_note_rounded, color: Colors.white, size: 72),
    );
  }

  Widget _playButton() {
    return StreamBuilder<PlayerState>(
      stream: _player.playerStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        final playing = state?.playing ?? false;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: widget.trackId == null ? null : _saveToSpotify,
              child: Row(
                children: [
                  _isSavingTrack
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Icon(
                          _isTrackSaved
                              ? Icons.check_circle
                              : Icons.add_circle_outline,
                          color: Colors.white,
                          size: 18,
                        ),
                  const SizedBox(width: 8),
                  Text(
                    _isTrackSaved ? 'SALVO NO SPOTIFY' : 'SALVAR NO SPOTIFY',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => playing ? _player.pause() : _player.play(),
              child: Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.02),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 15,
                        spreadRadius: -3,
                        offset: const Offset(0, 10),
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 6,
                        spreadRadius: -4,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    playing ? Icons.pause : Icons.play_arrow,
                    color: Color(0XFF110B1A),
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _nextCardButton() {
    return SizedBox(
      width: double.infinity,
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
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, size: 18),
          ],
        ),
      ),
    );
  }
}
