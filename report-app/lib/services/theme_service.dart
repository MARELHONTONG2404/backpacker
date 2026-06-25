import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Menyimpan preferensi mode terang / gelap aplikasi.
class ThemeService extends ChangeNotifier {
  ThemeService(this._themeMode);

  static const _storageKey = 'app_theme_mode';

  ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;

  bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static ThemeMode _parseMode(String? stored) {
    switch (stored) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  static String _encodeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.light:
        return 'light';
      case ThemeMode.system:
        return 'system';
    }
  }

  static Future<ThemeService> load() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_storageKey);
    return ThemeService(_parseMode(stored));
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, _encodeMode(mode));
  }

  Future<void> toggle(BuildContext context) {
    final effectiveDark = isDark(context);
    return setThemeMode(effectiveDark ? ThemeMode.light : ThemeMode.dark);
  }
}
