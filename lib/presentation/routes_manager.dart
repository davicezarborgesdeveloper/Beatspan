import 'package:flutter/material.dart';

import '../app/di.dart';
import 'change_spotify/change_spotify_view.dart';
import 'contact/contact_view.dart';
import 'faqs/faqs_view.dart';
import 'first_time/first_time_view.dart';
import 'game/game_view.dart';
import 'home/home_view.dart';
import 'rules/rules_view.dart';
import 'settings/settings_view.dart';
import 'splash/splash_view.dart';
import 'spotify_free_transition/spotify_free_transition.dart';

class Routes {
  static const String splashRoute = '/splash';
  static const String firstTimeRoute = '/first';
  static const String rulesRoute = '/rules';
  static const String changeSpotifyRoute = '/change-spotify';
  static const String changeSpotifyFreeRoute = '/connect-spotify-free';

  static const String homeRoute = '/home';
  static const String faqRoute = '/faq';
  static const String settingsRoute = '/settings';
  static const String contactRoute = '/contact';
  static const String languageRoute = '/language';
  static const String gameRoute = '/game';
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashView());
      case Routes.firstTimeRoute:
        return _fadeRoute(const FirstTimeView());
      case Routes.rulesRoute:
        return MaterialPageRoute(builder: (_) => const RulesView());
      case Routes.changeSpotifyRoute:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const ChangeSpotifyView(),
        );
      case Routes.changeSpotifyFreeRoute:
        return MaterialPageRoute(builder: (_) => const SpotifyFreeTransition());
      case Routes.homeRoute:
        return _fadeRoute(const HomeView());
      case Routes.faqRoute:
        initFaqsModule();
        return MaterialPageRoute(builder: (_) => const FaqsView());
      case Routes.settingsRoute:
        return MaterialPageRoute(builder: (_) => const SettingsView());
      case Routes.contactRoute:
        return MaterialPageRoute(builder: (_) => const ContactView());
      case Routes.gameRoute:
        return MaterialPageRoute(builder: (_) => const GameView());
      default:
        return undefinedRoute();
    }
  }

  static Route<dynamic> _fadeRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionDuration: const Duration(milliseconds: 450),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: child,
        );
      },
    );
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
