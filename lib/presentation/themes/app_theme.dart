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
      brightness: Brightness.light,
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
      unselectedItemColor: AppColors.bsGray500,
      showUnselectedLabels: true,
    ),
    cardColor: AppColors.surface,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.onBackground),
      bodyMedium: TextStyle(color: AppColors.onBackground),
      titleLarge: TextStyle(color: AppColors.onBackground, fontWeight: FontWeight.bold),
      labelLarge: TextStyle(color: AppColors.petsoliveInfo),
      labelSmall: TextStyle(color: AppColors.bsGray700),
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
    extensions: <ThemeExtension<dynamic>>[
      CustomColors(
        success: AppColors.petsoliveSuccess,
        warning: AppColors.petsoliveWarning,
        info: AppColors.petsoliveInfo,
        danger: AppColors.petsoliveDanger,
      ),
    ],
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
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: AppColors.darkBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkAppBar,
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
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      showUnselectedLabels: true,
    ),
    cardColor: AppColors.darkSurface,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.darkOnBackground),
      bodyMedium: TextStyle(color: AppColors.darkOnBackground),
      titleLarge: TextStyle(color: AppColors.darkOnBackground, fontWeight: FontWeight.bold),
      labelLarge: TextStyle(color: AppColors.darkSecondary),
      labelSmall: TextStyle(color: AppColors.bsGray300),
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
    extensions: <ThemeExtension<dynamic>>[
      CustomColors(
        success: AppColors.petsoliveSuccess,
        warning: AppColors.petsoliveWarning,
        info: AppColors.darkSecondary,
        danger: AppColors.petsoliveDanger,
      ),
    ],
  );
}

// Success, warning, info, danger gibi özel renkler için ThemeExtension
class CustomColors extends ThemeExtension<CustomColors> {
  final Color? success;
  final Color? warning;
  final Color? info;
  final Color? danger;

  const CustomColors({this.success, this.warning, this.info, this.danger});

  @override
  CustomColors copyWith({Color? success, Color? warning, Color? info, Color? danger}) {
    return CustomColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      danger: danger ?? this.danger,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) return this;
    return CustomColors(
      success: Color.lerp(success, other.success, t),
      warning: Color.lerp(warning, other.warning, t),
      info: Color.lerp(info, other.info, t),
      danger: Color.lerp(danger, other.danger, t),
    );
  }
} 