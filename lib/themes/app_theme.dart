import 'package:flutter/material.dart';
import 'package:restockly/themes/color_const.dart';

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      fontFamily: 'Inter',
      primaryColor: primary,
      scaffoldBackgroundColor: surface,
      progressIndicatorTheme: ProgressIndicatorThemeData(color: textPrimary),
      appBarTheme: AppBarTheme(
        scrolledUnderElevation: 0,
        backgroundColor: surface,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: textPrimary,
          fontSize: 22,
        ),
      ),
      iconTheme: const IconThemeData(color: textPrimary),
      textTheme: const TextTheme(bodyMedium: TextStyle(color: textPrimary)),
    );
  }
}
