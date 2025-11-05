import 'package:flutter/material.dart';

class ColorManager {
  static Color primary = HexColor.fromHex('#2CCBF5');
  static Color secondary = HexColor.fromHex('#624595');
  static Color ternary = HexColor.fromHex('#29107D');
  static Color ternaryLight = HexColor.fromHex('#5E1B88');
  static Color quaternary = HexColor.fromHex('#DE436B');
  static Color quaternaryLight = HexColor.fromHex('#ED8E4C');

  static Color black = HexColor.fromHex('#000000');
  static Color white = HexColor.fromHex('#FFFFFF');
  static Color yellowLink = HexColor.fromHex('#FFC850');
}

extension HexColor on Color {
  static Color fromHex(String hexColorString) {
    hexColorString = hexColorString.replaceAll('#', '');
    if (hexColorString.length == 6) {
      hexColorString = 'FF$hexColorString';
    }
    return Color(int.parse(hexColorString, radix: 16));
  }
}
