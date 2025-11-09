import 'dart:async';
import 'package:spotify_sdk/spotify_sdk.dart';

class SpotifyService {
  final String clientId;
  final String redirectUrl;
  final String scopes;

  SpotifyService({
    required this.clientId,
    required this.redirectUrl,
    this.scopes =
        'app-remote-control,user-read-playback-state,user-modify-playback-state,playlist-read-private',
  });

  Future<bool> connect({String? accessToken}) async {
    final connected = await SpotifySdk.connectToSpotifyRemote(
      clientId: clientId,
      redirectUrl: redirectUrl,
      scope: scopes,
      accessToken: accessToken,
    );
    return connected;
  }

  /// Token temporário para Web API
  Future<String> getAccessToken() async {
    final token = await SpotifySdk.getAccessToken(
      clientId: clientId,
      redirectUrl: redirectUrl,
      scope: scopes,
    );
    return token;
  }

  Future<bool> authorizeAndConnect() async {
    final token = await getAccessToken();
    return connect(accessToken: token);
  }

  Future<bool> disconnect() => SpotifySdk.disconnect();
}
