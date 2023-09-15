import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color primaryColorBackground = Color(0xFFFFFFFF);

  //Text Colors
  static const Color textColor = Color(0xFF595959);
  static const Color darkTextColor = Color(0xFF121212);
  static Color lightTextColor = const Color(0xFF0F0F0F).withOpacity(0.6);

  //Action Colors
  static const Color disabledColor = Color(0xFFEBE9E9);
  static const Color borderColor = Color(0xFFD1D1D1);
  static const Color circleBorderColor = Color(0xFFD9D9D9);
  static const Color textBorderColor = Color(0xFFFEE6F2);
  static const Color textFieldColor = Color(0xFFFFF5F9);

  //Other Colors
  static const Color red = Color(0xFFFF1F1F);
  static const Color green = Color(0xFF1FFF1F);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Colors.grey;
  static const Color transparent = Colors.transparent;

  static const int _primaryColorValue = 0xFF941D3A;

  static const MaterialColor primaryColor = MaterialColor(
    _primaryColorValue,
    <int, Color>{
      50: Color(0xFFFCE4EB),
      100: Color(0xFFF8B3C5),
      200: Color(0xFFF484A1),
      300: Color(0xFFF2557C),
      400: Color(0xFFEF2B5E),
      500: Color(_primaryColorValue),
      600: Color(0xFFE30A67),
      700: Color(0xFFD8085D),
      800: Color(0xFFCB0654),
      900: Color(0xFFBF044A),
    },
  );
}
