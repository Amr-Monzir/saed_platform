import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends StateNotifier<ThemeMode> {
  ThemeController(this._prefs) : super(ThemeMode.system) {
    _load();
  }
  final SharedPreferences _prefs;

  static const _key = 'theme_mode';

  void _load() {
    final value = _prefs.getString(_key);
    if (value == 'light') state = ThemeMode.light;
    if (value == 'dark') state = ThemeMode.dark;
    if (value == 'system' || value == null) state = ThemeMode.system;
  }

  Future<void> setMode(ThemeMode mode) async {
    state = mode;
    await _prefs.setString(_key, switch (mode) { ThemeMode.light => 'light', ThemeMode.dark => 'dark', _ => 'system' });
  }
}

final sharedPrefsProvider = Provider<SharedPreferences>((ref) => throw UnimplementedError());

final themeControllerProvider = StateNotifierProvider<ThemeController, ThemeMode>((ref) {
  final prefs = ref.watch(sharedPrefsProvider);
  return ThemeController(prefs);
});


