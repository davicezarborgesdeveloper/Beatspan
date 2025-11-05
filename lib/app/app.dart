import 'package:flutter/material.dart';
import '../presentation/routes_manager.dart';
import '../presentation/resource/theme_manager.dart';

// ignore: must_be_immutable
class MyApp extends StatefulWidget {
  MyApp._internal();
  int appState = 0;
  static MyApp get instance => MyApp._internal();

  factory MyApp() => instance;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: getApplicationTheme(),
      onGenerateRoute: RouteGenerator.getRoute,
      initialRoute: Routes.splashRoute,
    );
  }
}
