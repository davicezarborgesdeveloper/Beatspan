import 'dart:convert';

import 'package:http/http.dart' as http;

class SpotifyWebApi {
  final String accessToken;

  SpotifyWebApi(this.accessToken);

  Map<String, String> get _h => {
    'Authorization': 'Bearer $accessToken',
    'Content-Type': 'application/json',
  };

  Future<String?> getTrackPreviewUrl(String trackId) async {
    final track = await getTrack(trackId);
    // A Spotify Web API deixou de fornecer preview_url para a maioria dos
    // apps/faixas desde nov/2024 — geralmente vem null independente da faixa.
    return track?.previewUrl;
  }

  Future<SpotifyTrackInfo?> getTrack(String trackId) async {
    final url = Uri.parse('https://api.spotify.com/v1/tracks/$trackId');
    final r = await http.get(url, headers: _h);

    if (r.statusCode != 200) return null;

    final j = json.decode(r.body) as Map<String, dynamic>;
    final artists = (j['artists'] as List<dynamic>?)
        ?.map((a) => (a as Map<String, dynamic>)['name'] as String?)
        .whereType<String>()
        .toList();

    final images = (j['album'] as Map<String, dynamic>?)?['images']
        as List<dynamic>?;
    final albumArtUrl = images?.isNotEmpty == true
        ? (images!.first as Map<String, dynamic>)['url'] as String?
        : null;

    return SpotifyTrackInfo(
      name: j['name'] as String?,
      artist: artists?.isNotEmpty == true ? artists!.first : null,
      previewUrl: j['preview_url'] as String?,
      albumArtUrl: albumArtUrl,
    );
  }
}

class SpotifyTrackInfo {
  final String? name;
  final String? artist;
  final String? previewUrl;
  final String? albumArtUrl;

  const SpotifyTrackInfo({
    this.name,
    this.artist,
    this.previewUrl,
    this.albumArtUrl,
  });
}
