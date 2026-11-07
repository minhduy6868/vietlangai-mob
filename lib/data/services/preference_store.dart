import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PreferenceStore {
  ThemeMode get themeMode;
  Locale get locale;
  Future<void> setThemeMode(ThemeMode mode);
  Future<void> setLocale(Locale locale);
}

class SharedPreferenceStore implements PreferenceStore {
  SharedPreferenceStore(this._prefs);

  final SharedPreferences _prefs;

  @override
  ThemeMode get themeMode {
    return switch (_prefs.getString('theme')) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  @override
  Locale get locale => Locale(_prefs.getString('locale') ?? 'vi');

  @override
  Future<void> setThemeMode(ThemeMode mode) {
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    return _prefs.setString('theme', value);
  }

  @override
  Future<void> setLocale(Locale locale) => _prefs.setString('locale', locale.languageCode);
}

class MemoryPreferenceStore implements PreferenceStore {
  MemoryPreferenceStore({this.themeMode = ThemeMode.system, this.locale = const Locale('vi')});

  @override
  ThemeMode themeMode;

  @override
  Locale locale;

  @override
  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode = mode;
  }

  @override
  Future<void> setLocale(Locale value) async {
    locale = value;
  }
}
