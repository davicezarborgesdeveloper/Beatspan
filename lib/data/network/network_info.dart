import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;
  NetworkInfoImpl(this._connectivity);

  @override
  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();

    if (results.isEmpty) return false;

    return !results.contains(ConnectivityResult.none);
  }
}
