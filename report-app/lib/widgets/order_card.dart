import 'package:flutter/material.dart';

import '../models/order.dart';
import '../theme/app_theme.dart';
import 'common_widgets.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.order,
    required this.onTap,
    this.trailing,
    this.roleLabel,
  });

  final OrderItem order;
  final VoidCallback onTap;
  final Widget? trailing;
  final String? roleLabel;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      categoryIcon(order.category),
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          order.categoryLabel,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  StatusBadge(label: order.statusLabel, status: order.status),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  _MetaChip(
                    icon: Icons.payments_outlined,
                    label: 'Rp ${formatCurrency(order.rewardAmount)}',
                    emphasized: true,
                  ),
                  if (order.locationText != null && order.locationText!.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: _MetaChip(
                        icon: Icons.location_on_outlined,
                        label: order.locationText!,
                      ),
                    ),
                  ],
                ],
              ),
              if (order.description != null && order.description!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  order.description!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.textSecondary, height: 1.4),
                ),
              ],
              if (order.creatorName != null || order.executorName != null || roleLabel != null) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    if (order.creatorName != null)
                      _MetaChip(icon: Icons.person_outline, label: order.creatorName!),
                    if (order.executorName != null)
                      _MetaChip(icon: Icons.engineering_outlined, label: order.executorName!),
                    if (roleLabel != null && roleLabel!.isNotEmpty)
                      _MetaChip(icon: Icons.badge_outlined, label: roleLabel!),
                  ],
                ),
              ],
              if (trailing != null) ...[
                const SizedBox(height: 14),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.icon,
    required this.label,
    this.emphasized = false,
  });

  final IconData icon;
  final String label;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: emphasized
            ? AppColors.primary.withValues(alpha: 0.08)
            : AppColors.background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: emphasized ? AppColors.primary : AppColors.textSecondary,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: emphasized ? FontWeight.w700 : FontWeight.w500,
                color: emphasized ? AppColors.primaryDark : AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
