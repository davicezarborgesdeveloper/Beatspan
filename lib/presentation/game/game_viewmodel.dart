enum QrValidationResult { invalid, spotifyTrack }

class GameViewModel {
  static const String _spotifyPrefix =
      'https://open.spotify.com/intl-pt/track/';

  QrValidationResult validate(String rawValue) {
    final uri = Uri.tryParse(rawValue);
    final isWebUrl =
        uri != null && (uri.scheme == 'http' || uri.scheme == 'https');

    final isSpotifyTrack = isWebUrl && rawValue.startsWith(_spotifyPrefix);
    if (!isSpotifyTrack) {
      return QrValidationResult.invalid;
    }
    return QrValidationResult.spotifyTrack;
  }

  bool isValidSpotifyLink(String value) {
    final uri = Uri.tryParse(value);
    if (uri == null) return false;
    if (uri.scheme != 'http' && uri.scheme != 'https') return false;
    return value.startsWith(_spotifyPrefix);
  }

  String? extractTrackId(String url) {
    if (!isValidSpotifyLink(url)) return null;
    final uri = Uri.tryParse(url);
    if (uri == null) return null;

    final segments = uri.pathSegments;
    if (segments.length < 3) return null;

    return segments[2];
  }

  String? toSpotifyUri(String url) {
    final id = extractTrackId(url);
    if (id == null) return null;
    return 'spotify:track:$id';
  }
}
