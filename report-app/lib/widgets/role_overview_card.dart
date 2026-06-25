import 'package:flutter/material.dart';

import '../l10n/l10n_extension.dart';
import '../theme/app_theme.dart';
import 'common_widgets.dart';

/// Kartu ringkasan dua peran: pembuat tugas & pelaksana tugas.
class RoleOverviewCard extends StatelessWidget {
  const RoleOverviewCard({
    super.key,
    this.onTakeTasks,
    this.onCreateTask,
    this.compact = false,
  });

  final VoidCallback? onTakeTasks;
  final VoidCallback? onCreateTask;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SectionCard(
      title: l10n.roleOverviewTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!compact) ...[
            _FlowSteps(
              steps: [
                l10n.flowStepCreate,
                l10n.flowStepGive,
                l10n.flowStepTake,
                l10n.flowStepComplete,
              ],
            ),
            const SizedBox(height: 14),
          ],
          Row(
            children: [
              Expanded(
                child: _RoleTile(
                  icon: Icons.edit_note_outlined,
                  color: AppColors.primary,
                  title: l10n.roleCreatorTitle,
                  description: l10n.roleCreatorDesc,
                  action: l10n.giveTaskAction,
                  onTap: onCreateTask,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _RoleTile(
                  icon: Icons.handshake_outlined,
                  color: AppColors.secondary,
                  title: l10n.roleExecutorTitle,
                  description: l10n.roleExecutorDesc,
                  action: l10n.takeTaskAction,
                  onTap: onTakeTasks,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FlowSteps extends StatelessWidget {
  const _FlowSteps({required this.steps});

  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: steps
          .map(
            (step) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(step, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
            ),
          )
          .toList(),
    );
  }
}

class _RoleTile extends StatelessWidget {
  const _RoleTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
    required this.action,
    this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String description;
  final String action;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.07),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 26),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.35),
              ),
              if (onTap != null) ...[
                const SizedBox(height: 10),
                Text(
                  action,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
