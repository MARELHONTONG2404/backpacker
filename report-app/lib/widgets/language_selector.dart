import 'package:flutter/material.dart';

import '../l10n/l10n_extension.dart';
import '../app/app_locale_scope.dart';
import '../theme/app_theme.dart';

/// Tombol bahasa di AppBar — paling mudah ditemukan.
class LanguageMenuButton extends StatelessWidget {
  const LanguageMenuButton({
    super.key,
    this.iconColor,
  });

  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final localeService = AppLocaleScope.of(context);
    final current = localeService.locale.languageCode == 'zh' ? '中文' : 'ID';

    return PopupMenuButton<Locale>(
      tooltip: l10n.language,
      onSelected: localeService.setLocale,
      itemBuilder: (context) => [
        PopupMenuItem(
          value: const Locale('id'),
          child: Row(
            children: [
              if (localeService.locale.languageCode == 'id')
                const Icon(Icons.check, size: 18, color: AppColors.primary)
              else
                const SizedBox(width: 18),
              const SizedBox(width: 8),
              Text(l10n.languageId),
            ],
          ),
        ),
        PopupMenuItem(
          value: const Locale('zh'),
          child: Row(
            children: [
              if (localeService.locale.languageCode == 'zh')
                const Icon(Icons.check, size: 18, color: AppColors.primary)
              else
                const SizedBox(width: 18),
              const SizedBox(width: 8),
              Text(l10n.languageZh),
            ],
          ),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.language, size: 20, color: iconColor ?? AppColors.primary),
            const SizedBox(width: 4),
            Text(
              current,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: iconColor ?? AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Pemilih bahasa Indonesia / 中文 (untuk halaman profil).
class LanguageSelector extends StatelessWidget {
  const LanguageSelector({
    super.key,
    this.compact = false,
  });

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final localeService = AppLocaleScope.of(context);

    if (compact) {
      return SegmentedButton<Locale>(
        segments: [
          ButtonSegment(value: const Locale('id'), label: Text(l10n.languageId)),
          ButtonSegment(value: const Locale('zh'), label: Text(l10n.languageZh)),
        ],
        selected: {localeService.locale},
        onSelectionChanged: (value) {
          localeService.setLocale(value.first);
        },
      );
    }

    return DropdownButton<Locale>(
      isExpanded: true,
      value: localeService.locale,
      underline: const SizedBox.shrink(),
      items: [
        DropdownMenuItem(value: const Locale('id'), child: Text(l10n.languageId)),
        DropdownMenuItem(value: const Locale('zh'), child: Text(l10n.languageZh)),
      ],
      onChanged: (locale) {
        if (locale != null) localeService.setLocale(locale);
      },
    );
  }
}
