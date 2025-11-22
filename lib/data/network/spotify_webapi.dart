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
    final url = Uri.parse('https://api.spotify.com/v1/tracks/$trackId');
    final r = await http.get(url, headers: _h);

    if (r.statusCode != 200) return null;

    final j = json.decode(r.body) as Map<String, dynamic>;
    // pode ser null em algumas faixas (depende do catálogo)
    return j['preview_url'] as String?;
  }
}
