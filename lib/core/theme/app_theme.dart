import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF36BFFA);
  static const Color secondaryColor = Color(0xFF42A5F5);
  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color surfaceColor = Colors.white;
  static const Color successColor = Color(0xFF92C73D);
  static const Color blueLightColor = Color(0xFFEDF9FF);
  static const Color skyLightColor = Color(0xFFD2F1FF);
  static const Color lightGrayColor = Color(0xFFD9D9D9);

  static const Color errorColor = Color(0xFFFF4B4B);
  static const Color textColor = Color(0xFF4B4B4B);
  static const Color textSecondaryColor = Color(0xFF777777);
  static const Color textGrayColor = Color(0xFFA3A3A3);
  static const Color textGrayLightColor = Color(0xFFAFAFAF);
  static const Color textBlueColor = Color(0xFF3393FF);
  static const Color textPrimaryColor = Color(0xFF00BBFF);
  static const Color azureColor = Color(0xFF00AAFF);
  static const Color pinkColor = Color(0xFFFF6CA5);

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
      titleMedium: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        color: textColor,
      ),
      titleSmall: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: textColor,
      ),
      displayLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w900,
        color: textColor,
      ),
      displayMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w900,
        color: textColor,
      ),
      displaySmall: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: textColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: textColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: textColor,
        fontWeight: FontWeight.w800,
      ),
      labelLarge: TextStyle(fontSize: 14, color: textSecondaryColor),
      labelMedium: TextStyle(fontSize: 12, color: textSecondaryColor),
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
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: const BorderSide(
          color: AppTheme.buttonPrimaryDisabledBackground,
          width: 2,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: textSecondaryColor,
          fontFamily: 'Nunito',
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: backgroundColor,
          fontFamily: 'Nunito',
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: textSecondaryColor,
          fontFamily: 'Nunito',
          decoration: TextDecoration.underline,
        ),
      ),
    ),
    cardTheme: CardTheme(
      color: surfaceColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderSide: BorderSide(color: textGrayLightColor),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: textGrayLightColor),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: textGrayLightColor),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: errorColor),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: errorColor),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      hintStyle: TextStyle(
        fontSize: 20,
        color: textGrayLightColor,
        fontWeight: FontWeight.w800,
        fontFamily: 'Nunito',
      ),
      labelStyle: TextStyle(
        fontSize: 20,
        color: textGrayLightColor,
        fontWeight: FontWeight.w800,
        fontFamily: 'Nunito',
      ),
    ),
  );
}

class Spacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 40.0;
}
