import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  static const String _themeKey = 'theme_mode';
  static const String _localeKey = 'locale';

  SettingsCubit()
    : super(
        const SettingsState(themeMode: ThemeMode.system, locale: Locale('en')),
      );

  /// Initialize Settings by reading from SharedPreferences
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    // Load theme
    final themeString = prefs.getString(_themeKey);
    ThemeMode mode = ThemeMode.system;
    if (themeString == 'light') mode = ThemeMode.light;
    if (themeString == 'dark') mode = ThemeMode.dark;

    // Load locale
    final localeString = prefs.getString(_localeKey) ?? 'en';

    emit(state.copyWith(themeMode: mode, locale: Locale(localeString)));
  }

  /// Toggle dark/light mode
  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final newMode = state.themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;

    await prefs.setString(
      _themeKey,
      newMode == ThemeMode.dark ? 'dark' : 'light',
    );
    emit(state.copyWith(themeMode: newMode));
  }

  /// Set a specific locale
  Future<void> setLocale(Locale newLocale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, newLocale.languageCode);
    await prefs.setBool('is_language_set', true);
    emit(state.copyWith(locale: newLocale));
  }

  /// Toggle language between English and Arabic
  Future<void> toggleLanguage() async {
    final newLocale = state.locale.languageCode == 'en'
        ? const Locale('ar')
        : const Locale('en');
    await setLocale(newLocale);
  }
}
