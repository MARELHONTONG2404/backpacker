import 'package:flutter/material.dart';

import '../app/app_theme_scope.dart';
import '../l10n/l10n_extension.dart';
import '../theme/app_palette.dart';
import '../theme/app_theme.dart';

/// Tombol mode tema di AppBar — pilih Terang / Gelap / Sistem.
class ThemeMenuButton extends StatelessWidget {
  const ThemeMenuButton({super.key, this.iconColor});

  final Color? iconColor;

  IconData _iconForMode(ThemeMode mode, BuildContext context) {
    switch (mode) {
      case ThemeMode.light:
        return Icons.light_mode_rounded;
      case ThemeMode.dark:
        return Icons.dark_mode_rounded;
      case ThemeMode.system:
        return Icons.brightness_auto_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final themeService = AppThemeScope.of(context);
    final selected = themeService.themeMode;
    final color = iconColor ?? Theme.of(context).colorScheme.primary;

    return PopupMenuButton<ThemeMode>(
      tooltip: l10n.appearance,
      initialValue: selected,
      onSelected: themeService.setThemeMode,
      position: PopupMenuPosition.under,
      itemBuilder: (context) => [
        _themeItem(
          context,
          value: ThemeMode.light,
          selected: selected,
          icon: Icons.wb_sunny_outlined,
          label: l10n.themeLight,
        ),
        _themeItem(
          context,
          value: ThemeMode.dark,
          selected: selected,
          icon: Icons.nights_stay_outlined,
          label: l10n.themeDark,
        ),
        _themeItem(
          context,
          value: ThemeMode.system,
          selected: selected,
          icon: Icons.brightness_auto_outlined,
          label: l10n.themeSystem,
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Icon(
          _iconForMode(selected, context),
          color: color,
        ),
      ),
    );
  }

  PopupMenuItem<ThemeMode> _themeItem(
    BuildContext context, {
    required ThemeMode value,
    required ThemeMode selected,
    required IconData icon,
    required String label,
  }) {
    final palette = context.palette;
    final isSelected = value == selected;
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isSelected ? AppColors.primary : palette.textSecondary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.primary : palette.textPrimary,
              ),
            ),
          ),
          if (isSelected)
            const Icon(Icons.check_rounded, size: 18, color: AppColors.primary),
        ],
      ),
    );
  }
}

/// Pemilih mode tampilan di halaman profil.
class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final themeService = AppThemeScope.of(context);
    final palette = context.palette;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.themeModeHint,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: palette.textSecondary,
                height: 1.45,
              ),
        ),
        const SizedBox(height: 12),
        SegmentedButton<ThemeMode>(
          segments: [
            ButtonSegment(
              value: ThemeMode.light,
              label: Text(l10n.themeLight),
              icon: const Icon(Icons.wb_sunny_outlined, size: 18),
            ),
            ButtonSegment(
              value: ThemeMode.dark,
              label: Text(l10n.themeDark),
              icon: const Icon(Icons.nights_stay_outlined, size: 18),
            ),
            ButtonSegment(
              value: ThemeMode.system,
              label: Text(l10n.themeSystem),
              icon: const Icon(Icons.brightness_auto_outlined, size: 18),
            ),
          ],
          selected: {themeService.themeMode},
          onSelectionChanged: (value) => themeService.setThemeMode(value.first),
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) return AppColors.primary;
              return palette.textSecondary;
            }),
          ),
        ),
      ],
    );
  }
}
