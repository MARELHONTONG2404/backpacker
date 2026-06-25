import 'package:flutter/material.dart';

import '../l10n/l10n_extension.dart';
import '../models/backpacker_profile.dart';
import '../theme/app_theme.dart';
import 'common_widgets.dart';

class BackpackerRulesCard extends StatelessWidget {
  const BackpackerRulesCard({super.key, this.profile});

  final BackpackerProfile? profile;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SectionCard(
      title: l10n.rulesTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (profile != null)
            Text(
              l10n.reputationMinHint(profile!.minReputationToTake),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          if (profile != null) const SizedBox(height: 8),
          _RuleRow(icon: Icons.monetization_on_outlined, text: l10n.rulesCoins),
          const SizedBox(height: 8),
          _RuleRow(icon: Icons.star_outline, text: l10n.rulesReputation),
          const SizedBox(height: 8),
          _RuleRow(icon: Icons.block, text: l10n.rulesBlock),
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
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 13, height: 1.4))),
      ],
    );
  }
}
