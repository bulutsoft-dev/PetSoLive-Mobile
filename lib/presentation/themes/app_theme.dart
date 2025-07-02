import 'package:flutter/material.dart';
import 'colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      primaryContainer: AppColors.primaryVariant,
      secondary: AppColors.secondary,
      secondaryContainer: AppColors.secondaryVariant,
      background: AppColors.background,
      surface: AppColors.surface,
      error: AppColors.error,
      onPrimary: AppColors.onPrimary,
      onSecondary: AppColors.onSecondary,
      onBackground: AppColors.onBackground,
      onSurface: AppColors.onSurface,
      onError: AppColors.onError,
    ),
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
      elevation: 2,
      iconTheme: IconThemeData(color: AppColors.onPrimary),
      titleTextStyle: TextStyle(
        color: AppColors.onPrimary,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
    ),
    cardColor: AppColors.surface,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.onBackground),
      bodyMedium: TextStyle(color: AppColors.onBackground),
      titleLarge: TextStyle(color: AppColors.onBackground, fontWeight: FontWeight.bold),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary),
      ),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColors.primary,
      textTheme: ButtonTextTheme.primary,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.darkPrimary,
    colorScheme: ColorScheme.dark(
      primary: AppColors.darkPrimary,
      primaryContainer: AppColors.darkPrimaryVariant,
      secondary: AppColors.darkSecondary,
      secondaryContainer: AppColors.darkSecondaryVariant,
      background: AppColors.darkBackground,
      surface: AppColors.darkSurface,
      error: AppColors.darkError,
      onPrimary: AppColors.darkOnPrimary,
      onSecondary: AppColors.darkOnSecondary,
      onBackground: AppColors.darkOnBackground,
      onSurface: AppColors.darkOnSurface,
      onError: AppColors.darkOnError,
    ),
    scaffoldBackgroundColor: AppColors.darkBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkPrimary,
      foregroundColor: AppColors.darkOnPrimary,
      elevation: 2,
      iconTheme: IconThemeData(color: AppColors.darkOnPrimary),
      titleTextStyle: TextStyle(
        color: AppColors.darkOnPrimary,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkSurface,
      selectedItemColor: AppColors.darkPrimary,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
    ),
    cardColor: AppColors.darkSurface,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.darkOnBackground),
      bodyMedium: TextStyle(color: AppColors.darkOnBackground),
      titleLarge: TextStyle(color: AppColors.darkOnBackground, fontWeight: FontWeight.bold),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.darkPrimary),
      ),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColors.darkPrimary,
      textTheme: ButtonTextTheme.primary,
    ),
  );
} 