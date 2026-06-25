import 'package:flutter/material.dart';

import '../l10n/l10n_extension.dart';
import '../l10n/server_message_localizer.dart';
import '../models/backpacker_profile.dart';
import '../theme/app_theme.dart';
import 'app_animations.dart';
import 'glass_surface.dart';

enum GamificationBannerStyle {
  /// Koin + reputasi.
  compact,

  /// Buat Tugas: saldo + biaya publikasi.
  publish,
}

/// Banner koin tembaga dan reputasi.
class GamificationBanner extends StatelessWidget {
  const GamificationBanner({
    super.key,
    required this.profile,
    this.style = GamificationBannerStyle.compact,
    this.loading = false,
    this.errorMessage,
    this.onRetry,
    this.embedded = false,
  });

  final BackpackerProfile? profile;
  final GamificationBannerStyle style;
  final bool loading;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final bool embedded;

  EdgeInsets get _margin => embedded
      ? EdgeInsets.zero
      : const EdgeInsets.fromLTRB(
          AppLayout.screenPadding,
          AppLayout.sectionGap,
          AppLayout.screenPadding,
          0,
        );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (loading) {
      return GlassSurface(
        blur: false,
        margin: _margin,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const BrandedLoadingIndicator(size: 28),
            const SizedBox(width: 12),
            Expanded(child: Text(l10n.loadingCoinsReputation)),
          ],
        ),
      );
    }

    if (errorMessage != null) {
      return GlassSurface(
        blur: false,
        margin: _margin,
        tint: Theme.of(context).colorScheme.errorContainer,
        opacity: 0.35,
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                localizeServerMessage(l10n, errorMessage!),
                style: const TextStyle(fontSize: 13),
              ),
            ),
            if (onRetry != null)
              TextButton(onPressed: onRetry, child: Text(l10n.retry)),
          ],
        ),
      );
    }

    final p = profile;
    if (p == null) return const SizedBox.shrink();

    if (style == GamificationBannerStyle.publish) {
      return GlassSurface(
        blur: false,
        margin: _margin,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Icon(Icons.monetization_on_outlined, color: AppColors.primary, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '${l10n.copperCoins}: ${p.copperCoins} · ${l10n.publishFeeHint(p.publishFee)}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: p.canAffordPublish ? AppColors.textRegular : Theme.of(context).colorScheme.error,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return EntranceFadeSlide(
      child: Container(
        margin: _margin,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withValues(alpha: 0.12),
              AppColors.secondary.withValues(alpha: 0.08),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: AppDecorations.cardShadow(elevation: 0.5),
        ),
        child: GlassSurface(
          blur: false,
          borderRadius: 18,
          opacity: 0.94,
          padding: EdgeInsets.all(style == GamificationBannerStyle.compact ? 12 : 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _StatTile(
                    icon: Icons.monetization_on_outlined,
                    label: l10n.copperCoins,
                    value: '${p.copperCoins}',
                    color: AppColors.primary,
                    compact: style == GamificationBannerStyle.compact,
                  ),
                  const SizedBox(width: 12),
                  _StatTile(
                    icon: Icons.star_rounded,
                    label: l10n.reputation,
                    value: '${p.reputationScore}',
                    color: p.canTakeTask ? AppColors.secondary : Theme.of(context).colorScheme.error,
                    compact: style == GamificationBannerStyle.compact,
                  ),
                ],
              ),
              if (!p.canTakeTask && style != GamificationBannerStyle.publish) ...[
                const SizedBox(height: 8),
                Text(
                  p.reputationBlockedMessage(l10n),
                  style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.error),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.compact = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: compact ? 16 : 18, color: color),
            const SizedBox(width: 4),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: (compact
                  ? Theme.of(context).textTheme.titleMedium
                  : Theme.of(context).textTheme.titleLarge)
              ?.copyWith(
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }
}
