enum QrValidationResult { invalid, spotifyTrack }

class GameViewModel {
  static const String _spotifyHost = 'open.spotify.com';

  QrValidationResult validate(String rawValue) {
    final isSpotifyTrack = isValidSpotifyLink(rawValue);
    if (!isSpotifyTrack) {
      return QrValidationResult.invalid;
    }
    return QrValidationResult.spotifyTrack;
  }

  bool isValidSpotifyLink(String value) {
    return extractTrackId(value) != null;
  }

  /// Aceita links de faixa do Spotify com ou sem prefixo de locale, ex:
  /// `https://open.spotify.com/track/<id>`
  /// `https://open.spotify.com/intl-pt/track/<id>`
  String? extractTrackId(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return null;
    if (uri.scheme != 'http' && uri.scheme != 'https') return null;
    if (uri.host != _spotifyHost) return null;

    final segments = uri.pathSegments;
    final trackIndex = segments.indexOf('track');
    if (trackIndex == -1 || trackIndex + 1 >= segments.length) return null;

    final id = segments[trackIndex + 1];
    return id.isEmpty ? null : id;
  }

  String? toSpotifyUri(String url) {
    final id = extractTrackId(url);
    if (id == null) return null;
    return 'spotify:track:$id';
  }
}
