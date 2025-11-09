import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/network/network_info.dart';
import '../data/network/spotify_service.dart';
import '../domain/usecase/faqs_usecase.dart';
import '../presentation/connect_spotify_premium/connect_spotify_premium_view_model.dart';
import '../presentation/faqs/faqs_view_model.dart';
import 'app_prefs.dart';

void systemChromeConfigure() async {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarContrastEnforced: false,
    ),
  );
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

final instance = GetIt.instance;

Future<void> initAppModule() async {
  final sharedPrefs = await SharedPreferences.getInstance();
  instance.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  instance.registerLazySingleton<AppPreferences>(
    () => AppPreferences(instance()),
  );

  instance.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(Connectivity()),
  );

  final clientId = '8e1f4c38cf5543f5929e19c1d503205c';
  final redirectUrl = 'https://hitster-d8ac4.firebaseapp.com/';

  instance.registerLazySingleton<SpotifyService>(
    () => SpotifyService(clientId: clientId, redirectUrl: redirectUrl),
  );
}

void initFaqsModule() {
  if (!GetIt.I.isRegistered<FaqsUseCase>()) {
    instance.registerFactory<FaqsUseCase>(() => FaqsUseCase(instance()));
    instance.registerFactory<FaqsViewModel>(() => FaqsViewModel(instance()));
  }
}

void initSpotifyModule() {
  if (!GetIt.I.isRegistered<SpotifyService>()) {
    instance.registerFactory<ConnectSpotifyPremiumViewModel>(() => instance());
  }
}
