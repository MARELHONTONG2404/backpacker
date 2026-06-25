import 'package:flutter/material.dart';

import 'app/app_locale_scope.dart';
import 'app/app_theme_scope.dart';
import 'l10n/app_localizations.dart';
import 'screens/splash_screen.dart';
import 'services/locale_service.dart';
import 'services/theme_service.dart';
import 'theme/app_scroll_behavior.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final localeService = await LocaleService.load();
  final themeService = await ThemeService.load();
  runApp(BackpackerApp(
    localeService: localeService,
    themeService: themeService,
  ));
}

class BackpackerApp extends StatelessWidget {
  const BackpackerApp({
    super.key,
    required this.localeService,
    required this.themeService,
  });

  final LocaleService localeService;
  final ThemeService themeService;

  @override
  Widget build(BuildContext context) {
    return AppLocaleScope(
      localeService: localeService,
      child: AppThemeScope(
        themeService: themeService,
        child: ListenableBuilder(
          listenable: Listenable.merge([localeService, themeService]),
          builder: (context, _) {
            return MaterialApp(
              title: 'Backpacker',
              debugShowCheckedModeBanner: false,
              scrollBehavior: const BackpackerScrollBehavior(),
              theme: AppTheme.light(),
              darkTheme: AppTheme.dark(),
              themeMode: themeService.themeMode,
              locale: localeService.locale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: const SplashScreen(),
            );
          },
        ),
      ),
    );
  }
}
