import 'package:flutter/material.dart';

import '../services/locale_service.dart';

class AppLocaleScope extends InheritedWidget {
  const AppLocaleScope({
    super.key,
    required this.localeService,
    required super.child,
  });

  final LocaleService localeService;

  static LocaleService of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppLocaleScope>()!.localeService;
  }

  @override
  bool updateShouldNotify(AppLocaleScope oldWidget) =>
      oldWidget.localeService.locale != localeService.locale;
}
