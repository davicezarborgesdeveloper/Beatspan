import 'package:flutter/material.dart';

import 'color_manager.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
    scaffoldBackgroundColor: ColorManager.black,
    canvasColor: ColorManager.black,
    appBarTheme: AppBarTheme(backgroundColor: ColorManager.black),
  );
}
