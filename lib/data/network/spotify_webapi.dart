import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class SpotifyWebApi {
  final String accessToken;

  SpotifyWebApi(this.accessToken);

  /// Timeout padrão para requisições HTTP (15 segundos)
  /// Previne requisições travadas indefinidamente
  static const Duration _defaultTimeout = Duration(seconds: 15);

  Map<String, String> get _h => {
    'Authorization': 'Bearer $accessToken',
    'Content-Type': 'application/json',
  };

  Future<String?> getTrackPreviewUrl(String trackId) async {
    try {
      final url = Uri.parse('https://api.spotify.com/v1/tracks/$trackId');
      final r = await http.get(url, headers: _h).timeout(_defaultTimeout);

      if (r.statusCode != 200) return null;

      final j = json.decode(r.body) as Map<String, dynamic>;
      // pode ser null em algumas faixas (depende do catálogo)
      return j['preview_url'] as String?;
    } on TimeoutException {
      // Log do timeout (pode ser integrado com analytics no futuro)
      return null;
    } catch (e) {
      // Outros erros de rede
      return null;
    }
  }
}
