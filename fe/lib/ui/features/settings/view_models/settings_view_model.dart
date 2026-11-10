import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app_providers.dart';

class SettingsState {
  const SettingsState({required this.themeMode, required this.locale});

  final ThemeMode themeMode;
  final Locale locale;

  SettingsState copyWith({ThemeMode? themeMode, Locale? locale}) {
    return SettingsState(themeMode: themeMode ?? this.themeMode, locale: locale ?? this.locale);
  }
}

class SettingsViewModel extends Notifier<SettingsState> {
  @override
  SettingsState build() {
    final preferences = ref.watch(preferenceStoreProvider);
    return SettingsState(themeMode: preferences.themeMode, locale: preferences.locale);
  }

  Future<void> setTheme(ThemeMode mode) async {
    await ref.read(preferenceStoreProvider).setThemeMode(mode);
    state = state.copyWith(themeMode: mode);
  }

  Future<void> setLocale(Locale locale) async {
    await ref.read(preferenceStoreProvider).setLocale(locale);
    state = state.copyWith(locale: locale);
  }
}

final settingsViewModelProvider = NotifierProvider<SettingsViewModel, SettingsState>(
  SettingsViewModel.new,
);
