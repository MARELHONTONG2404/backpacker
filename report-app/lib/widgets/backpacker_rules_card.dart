import 'package:flutter/material.dart';

import '../config/app_strings.dart';
import '../models/backpacker_profile.dart';
import '../theme/app_theme.dart';

/// Penjelasan singkat sistem koin & reputasi sesuai deskripsi pembimbing.
class BackpackerRulesCard extends StatelessWidget {
  const BackpackerRulesCard({super.key, this.profile});

  final BackpackerProfile? profile;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      color: AppColors.primary.withValues(alpha: 0.04),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        leading: const Icon(Icons.info_outline, color: AppColors.primary),
        title: Text(
          AppStrings.rulesTitle,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        subtitle: profile == null
            ? null
            : Text(
                AppStrings.reputationMinHint.replaceFirst('{min}', '${profile!.minReputationToTake}'),
                style: Theme.of(context).textTheme.bodySmall,
              ),
        children: const [
          _RuleRow(icon: Icons.monetization_on_outlined, text: AppStrings.rulesCoins),
          SizedBox(height: 8),
          _RuleRow(icon: Icons.star_outline, text: AppStrings.rulesReputation),
          SizedBox(height: 8),
          _RuleRow(icon: Icons.block, text: AppStrings.rulesBlock),
        ],
      ),
    );
  }
}

class _RuleRow extends StatelessWidget {
  const _RuleRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 13, height: 1.45))),
      ],
    );
  }
}
