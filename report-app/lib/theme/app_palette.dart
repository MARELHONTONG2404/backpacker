import 'package:flutter/material.dart';

import 'app_theme.dart';

/// Warna semantik yang menyesuaikan mode terang / gelap.
class AppPalette {
  const AppPalette._(this._brightness);

  factory AppPalette(Brightness brightness) => AppPalette._(brightness);

  final Brightness _brightness;

  bool get isDark => _brightness == Brightness.dark;

  Color get background => isDark ? const Color(0xFF0B1017) : AppColors.background;
  Color get surface => isDark ? const Color(0xFF151D2B) : AppColors.surface;
  Color get surfaceElevated => isDark ? const Color(0xFF1C2638) : AppColors.surface;
  Color get textPrimary => isDark ? const Color(0xFFE8EDF4) : AppColors.textPrimary;
  Color get textRegular => isDark ? const Color(0xFFB8C0CC) : AppColors.textRegular;
  Color get textSecondary => isDark ? const Color(0xFF8B95A5) : AppColors.textSecondary;
  Color get border => isDark ? const Color(0xFF2A3547) : AppColors.border;
  Color get glassBorder => isDark
      ? Colors.white.withValues(alpha: 0.1)
      : Colors.white.withValues(alpha: 0.65);
  Color get navIndicator => AppColors.primary.withValues(alpha: isDark ? 0.22 : 0.14);

  static AppPalette of(BuildContext context) =>
      AppPalette._(Theme.of(context).brightness);
}

extension AppPaletteContext on BuildContext {
  AppPalette get palette => AppPalette.of(this);
  bool get isDarkMode => palette.isDark;
}
