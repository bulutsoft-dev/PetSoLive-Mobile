import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeState {
  final ThemeMode themeMode;
  const ThemeState(this.themeMode);
}

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(ThemeMode.system));

  void setLight() => emit(const ThemeState(ThemeMode.light));
  void setDark() => emit(const ThemeState(ThemeMode.dark));
  void setSystem() => emit(const ThemeState(ThemeMode.system));
  void toggleTheme() {
    if (state.themeMode == ThemeMode.light) {
      emit(const ThemeState(ThemeMode.dark));
    } else {
      emit(const ThemeState(ThemeMode.light));
    }
  }
} 