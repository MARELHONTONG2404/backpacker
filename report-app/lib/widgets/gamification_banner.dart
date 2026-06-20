import 'package:flutter/material.dart';

import '../config/app_strings.dart';
import '../models/backpacker_profile.dart';
import '../theme/app_theme.dart';

/// Banner koin tembaga, reputasi, dan check-in harian.
class GamificationBanner extends StatelessWidget {
  const GamificationBanner({
    super.key,
    required this.profile,
    this.loading = false,
    this.checkinLoading = false,
    this.errorMessage,
    this.onCheckin,
    this.onRetry,
  });

  final BackpackerProfile? profile;
  final bool loading;
  final bool checkinLoading;
  final String? errorMessage;
  final VoidCallback? onCheckin;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Card(
        margin: EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
              SizedBox(width: 12),
              Text('Memuat koin & reputasi...'),
            ],
          ),
        ),
      );
    }

    if (errorMessage != null) {
      return Card(
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.35),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error),
              const SizedBox(width: 10),
              Expanded(child: Text(errorMessage!, style: const TextStyle(fontSize: 13))),
              if (onRetry != null)
                TextButton(onPressed: onRetry, child: const Text('Coba lagi')),
            ],
          ),
        ),
      );
    }

    final p = profile;
    if (p == null) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _StatTile(
                  icon: Icons.monetization_on_outlined,
                  label: AppStrings.copperCoins,
                  value: '${p.copperCoins}',
                  color: AppColors.primary,
                ),
                const SizedBox(width: 12),
                _StatTile(
                  icon: Icons.star_rounded,
                  label: AppStrings.reputation,
                  value: '${p.reputationScore}',
                  color: p.canTakeTask ? AppColors.secondary : Theme.of(context).colorScheme.error,
                ),
                const Spacer(),
                FilledButton.tonalIcon(
                  onPressed: p.canCheckinToday && !checkinLoading ? onCheckin : null,
                  icon: checkinLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.calendar_today_outlined, size: 18),
                  label: Text(p.canCheckinToday ? AppStrings.checkin : AppStrings.checkinDone),
                ),
              ],
            ),
            if (!p.canTakeTask) ...[
              const SizedBox(height: 8),
              Text(
                p.reputationBlockedMessage,
                style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.error),
              ),
            ],
          ],
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
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 4),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: color,
              ),
        ),
      ],
    );
  }
}
