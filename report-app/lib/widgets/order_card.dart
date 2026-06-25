import 'package:flutter/material.dart';

import '../l10n/l10n_extension.dart';
import '../models/order.dart';
import '../theme/app_theme.dart';
import '../theme/app_palette.dart';
import 'app_animations.dart';
import 'common_widgets.dart';
import 'glass_surface.dart';

class OrderCard extends StatefulWidget {
  const OrderCard({
    super.key,
    required this.order,
    required this.onTap,
    this.trailing,
    this.roleLabel,
    this.userId,
    this.onRate,
    this.animationIndex = 0,
  });

  final OrderItem order;
  final VoidCallback onTap;
  final Widget? trailing;
  final String? roleLabel;
  final int? userId;
  final VoidCallback? onRate;
  final int animationIndex;

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    final order = widget.order;

    return EntranceFadeSlide(
      index: widget.animationIndex,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(AppLayout.cardRadius),
            child: GlassSurface(
              blur: false,
              opacity: 0.95,
              elevation: 1,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary.withValues(alpha: 0.18),
                              AppColors.primary.withValues(alpha: 0.06),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
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
                              order.categoryLabel(l10n),
                              style: TextStyle(
                                color: palette.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      StatusBadge(label: order.statusLabel(l10n), status: order.status),
                      if (order.canRate(widget.userId)) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            l10n.needsRating,
                            style: const TextStyle(
                              color: AppColors.secondary,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _MetaChip(
                        icon: Icons.payments_outlined,
                        label: l10n.rewardAmountValue(formatCurrency(order.rewardAmount)),
                        emphasized: true,
                      ),
                      if (order.locationText != null && order.locationText!.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Expanded(
                          child: _MetaChip(
                            icon: Icons.location_on_outlined,
                            label: order.locationText!,
                            expand: true,
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
                      style: TextStyle(color: palette.textSecondary, height: 1.4),
                    ),
                  ],
                  if (order.creatorName != null ||
                      order.executorName != null ||
                      widget.roleLabel != null) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        if (order.creatorName != null)
                          _MetaChip(icon: Icons.person_outline, label: order.creatorName!),
                        if (order.executorName != null)
                          _MetaChip(icon: Icons.engineering_outlined, label: order.executorName!),
                        if (widget.roleLabel != null && widget.roleLabel!.isNotEmpty)
                          _MetaChip(icon: Icons.badge_outlined, label: widget.roleLabel!),
                      ],
                    ),
                  ],
                  if (order.canRate(widget.userId) && widget.onRate != null) ...[
                    const SizedBox(height: 14),
                    FilledButton.tonalIcon(
                      onPressed: widget.onRate,
                      icon: const Icon(Icons.star_rate_outlined),
                      label: Text(l10n.rateNow),
                      style: FilledButton.styleFrom(
                        foregroundColor: AppColors.secondary,
                        backgroundColor: AppColors.secondary.withValues(alpha: 0.12),
                      ),
                    ),
                  ],
                  if (order.isRated) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            index < (order.ratingScore ?? 0) ? Icons.star : Icons.star_border,
                            size: 16,
                            color: AppColors.secondary,
                          );
                        }),
                        const SizedBox(width: 8),
                        Text(
                          l10n.ratingLabel,
                          style: TextStyle(fontSize: 12, color: palette.textSecondary),
                        ),
                      ],
                    ),
                  ],
                  if (widget.trailing != null) ...[
                    const SizedBox(height: 14),
                    widget.trailing!,
                  ],
                ],
              ),
            ),
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
    this.expand = false,
  });

  final IconData icon;
  final String label;
  final bool emphasized;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      width: expand ? double.infinity : null,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: emphasized
            ? AppColors.primary.withValues(alpha: 0.08)
            : palette.background.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(10),
        border: emphasized
            ? Border.all(color: AppColors.primary.withValues(alpha: 0.12))
            : null,
      ),
      child: Row(
        mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: emphasized ? AppColors.primary : palette.textSecondary,
          ),
          const SizedBox(width: 4),
          if (expand)
            Expanded(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: emphasized ? FontWeight.w700 : FontWeight.w500,
                  color: emphasized ? AppColors.primaryDark : palette.textSecondary,
                ),
              ),
            )
          else
            Text(
              label,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                fontSize: 12,
                fontWeight: emphasized ? FontWeight.w700 : FontWeight.w500,
                color: emphasized ? AppColors.primaryDark : AppColors.textSecondary,
              ),
            ),
        ],
      ),
    );
  }
}
