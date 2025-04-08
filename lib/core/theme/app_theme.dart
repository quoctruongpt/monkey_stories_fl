import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF36BFFA);
  static const Color secondaryColor = Color(0xFF42A5F5);
  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color surfaceColor = Colors.white;

  static const Color errorColor = Color(0xFFFF4B4B);
  static const Color textColor = Color(0xFF4B4B4B);
  static const Color textSecondaryColor = Color(0xFF777777);
  static const Color textGrayColor = Color(0xFFA3A3A3);

  // Button colors
  static const Color buttonPrimaryDisabledBackground = Color(0xFFE5E5E5);
  static const Color buttonSecondaryDisabledBackground = Color(0xFFF5F5F5);
  static const Color buttonPrimaryDarkerColor = Color(0xFF0095C1);
  static const Color buttonPrimaryDisabledDarkerColor = Color(0xFFD6D6D6);
  static const Color buttonSecondaryDarkerColor = Color(0xFFE5E5E5);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryColor,
    fontFamily: 'Nunito',
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: surfaceColor,
      error: errorColor,
    ),
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      displayMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      displaySmall: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: textColor,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: textColor),
      bodyMedium: TextStyle(fontSize: 14, color: textColor),
      labelLarge: TextStyle(fontSize: 14, color: textSecondaryColor),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: textColor,
          fontFamily: 'Nunito',
        ),
      ),
    ),
    cardTheme: CardTheme(
      color: surfaceColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
