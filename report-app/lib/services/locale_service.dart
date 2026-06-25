import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Menyimpan dan mengelola locale aplikasi (id / zh).
class LocaleService extends ChangeNotifier {
  LocaleService(this._locale);

  static const _storageKey = 'app_locale';
  static const supportedLocales = [
    Locale('id'),
    Locale('zh'),
  ];

  Locale _locale;

  Locale get locale => _locale;

  static Future<LocaleService> load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_storageKey) ?? 'id';
    return LocaleService(Locale(code));
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, locale.languageCode);
  }
}
