import 'dart:ui';

import 'package:flutter/material.dart';

import '../../l10n/l10n_extension.dart';
import '../../theme/app_palette.dart';
import '../../theme/app_theme.dart';

class BackpackerNavBar extends StatelessWidget {
  const BackpackerNavBar({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    final bottom = MediaQuery.viewPaddingOf(context).bottom;

    final items = [
      (icon: Icons.explore_outlined, selected: Icons.explore, label: l10n.tabAvailable),
      (icon: Icons.assignment_outlined, selected: Icons.assignment, label: l10n.tabMine),
      (icon: Icons.add_circle_outline, selected: Icons.add_circle, label: l10n.tabCreate),
      (icon: Icons.account_circle_outlined, selected: Icons.account_circle, label: l10n.tabProfile),
    ];

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, bottom + 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            height: 64,
            decoration: BoxDecoration(
              color: palette.surface.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: palette.glassBorder),
              boxShadow: AppDecorations.cardShadow(elevation: 1.2, dark: palette.isDark),
            ),
            child: Row(
              children: List.generate(items.length, (index) {
                final item = items[index];
                final selected = selectedIndex == index;
                return Expanded(
                  child: InkWell(
                    onTap: () => onSelected(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: selected
                            ? LinearGradient(
                                colors: [
                                  AppColors.primary.withValues(alpha: palette.isDark ? 0.28 : 0.18),
                                  AppColors.primary.withValues(alpha: palette.isDark ? 0.12 : 0.08),
                                ],
                              )
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            selected ? item.selected : item.icon,
                            size: 22,
                            color: selected ? AppColors.primary : palette.textSecondary,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                              color: selected ? AppColors.primary : palette.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
