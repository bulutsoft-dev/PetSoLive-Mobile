import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LocalizationManager {
  static const supportedLocales = [
    Locale('en'),
    Locale('tr'),
  ];

  static const fallbackLocale = Locale('en');

  static const path = 'assets/translations';

  static Locale getDeviceLocale(BuildContext context) {
    final locale = context.deviceLocale;
    if (supportedLocales.contains(locale)) {
      return locale;
    }
    return fallbackLocale;
  }
} 