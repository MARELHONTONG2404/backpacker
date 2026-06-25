import 'package:flutter/material.dart';

import '../services/theme_service.dart';

class AppThemeScope extends InheritedWidget {
  const AppThemeScope({
    super.key,
    required this.themeService,
    required super.child,
  });

  final ThemeService themeService;

  static ThemeService of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppThemeScope>()!.themeService;
  }

  @override
  bool updateShouldNotify(AppThemeScope oldWidget) =>
      oldWidget.themeService.themeMode != themeService.themeMode;
}
