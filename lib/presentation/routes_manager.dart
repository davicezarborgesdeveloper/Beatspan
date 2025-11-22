import 'package:flutter/material.dart';

import '../app/di.dart';
import 'change_spotify/change_spotify_view.dart';
import 'connect_spotify_premium/connect_spotify_premium_view.dart';
import 'contact/contact_view.dart';
import 'country/country_view.dart';
import 'faqs/faqs_view.dart';
import 'home/home_view.dart';
import 'language/language_view.dart';
import 'settings/settings_view.dart';
import 'splash/splash_view.dart';

class Routes {
  static const String splashRoute = '/splash';
  static const String homeRoute = '/home';
  static const String faqRoute = '/faq';
  static const String settingsRoute = '/settings';
  static const String contactRoute = '/contact';
  static const String changeSpotifyRoute = '/change-spotify';
  static const String changeSpotifyPremiumRoute = '/connect-spotify-premium';
  static const String countryRoute = '/country';
  static const String languageRoute = '/language';
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashView());
      case Routes.countryRoute:
        return MaterialPageRoute(builder: (_) => const CountryView());
      case Routes.languageRoute:
        return MaterialPageRoute(builder: (_) => const LanguageView());
      case Routes.homeRoute:
        return MaterialPageRoute(builder: (_) => const HomeView());
      case Routes.faqRoute:
        initFaqsModule();
        return MaterialPageRoute(builder: (_) => const FaqsView());
      case Routes.settingsRoute:
        return MaterialPageRoute(builder: (_) => const SettingsView());
      case Routes.contactRoute:
        return MaterialPageRoute(builder: (_) => const ContactView());
      case Routes.changeSpotifyRoute:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const ChangeSpotifyView(),
        );
      case Routes.changeSpotifyPremiumRoute:
        return MaterialPageRoute(
          builder: (_) => const ConnectSpotifyPremiumView(),
        );
      default:
        return undefinedRoute();
    }
  }

  static Route<dynamic> undefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Rota Inexistente')),
        body: const Center(child: Text('Rota Inexistente')),
      ),
    );
  }
}
