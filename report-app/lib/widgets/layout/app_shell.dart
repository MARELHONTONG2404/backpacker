import 'dart:ui';

import 'package:flutter/material.dart';

import '../../l10n/l10n_extension.dart';
import '../../theme/app_palette.dart';
import '../../theme/app_theme.dart';
import '../backpacker_brand.dart';
import '../auth_background.dart';
import '../language_selector.dart';
import '../theme_selector.dart';
import 'backpacker_nav_bar.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.nickName,
    required this.tabIndex,
    required this.onTabSelected,
    required this.body,
  });

  final String? nickName;
  final int tabIndex;
  final ValueChanged<int> onTabSelected;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: Stack(
        children: [
          const Positioned.fill(child: AppBackground()),
          Column(
            children: [
              ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                  child: AppBar(
                    backgroundColor: palette.surface.withValues(alpha: 0.75),
                    surfaceTintColor: Colors.transparent,
                    toolbarHeight: 64,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const BackpackerBrandTitle(
                          compact: true,
                          showLogo: true,
                          showSubtitle: false,
                        ),
                        if (nickName != null)
                          Text(
                            l10n.welcomeHello(nickName!),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: palette.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                            overflow: TextOverflow.ellipsis,
                          )
                        else
                          Text(
                            l10n.appSubtitle,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                    actions: const [
                      ThemeMenuButton(),
                      LanguageMenuButton(),
                      SizedBox(width: 4),
                    ],
                  ),
                ),
              ),
              Expanded(child: body),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BackpackerNavBar(
        selectedIndex: tabIndex,
        onSelected: onTabSelected,
      ),
    );
  }
}
