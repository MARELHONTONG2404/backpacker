import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../l10n/l10n_extension.dart';
import '../../models/backpacker_profile.dart';
import '../../theme/app_theme.dart';
import '../app_animations.dart';
import '../backpacker_brand.dart';

/// Hero dashboard — identitas Backpacker dengan animasi jejak petualangan.
class DashboardHero extends StatefulWidget {
  const DashboardHero({
    super.key,
    required this.nickName,
    required this.profile,
    this.loading = false,
    this.onTakeTasks,
    this.onCreateTask,
  });

  final String? nickName;
  final BackpackerProfile? profile;
  final bool loading;
  final VoidCallback? onTakeTasks;
  final VoidCallback? onCreateTask;

  @override
  State<DashboardHero> createState() => _DashboardHeroState();
}

class _DashboardHeroState extends State<DashboardHero> with SingleTickerProviderStateMixin {
  late final AnimationController _float;

  @override
  void initState() {
    super.initState();
    _float = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _float.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final name = widget.nickName?.trim().isNotEmpty == true ? widget.nickName! : l10n.appName;

    return EntranceFadeSlide(
      child: Container(
        margin: const EdgeInsets.fromLTRB(
          AppLayout.screenPadding,
          AppLayout.sectionGap,
          AppLayout.screenPadding,
          0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppLayout.heroRadius),
          gradient: AppColors.brandGradient,
          boxShadow: [
            BoxShadow(
              color: AppColors.trail.withValues(alpha: 0.35),
              blurRadius: 28,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppLayout.heroRadius),
          child: Stack(
            children: [
              const Positioned.fill(
                child: FloatingTrailDecoration(opacity: 0.22),
              ),
              AnimatedBuilder(
                animation: _float,
                builder: (context, _) {
                  final drift = math.sin(_float.value * math.pi * 2) * 8;
                  return Positioned(
                    right: 12 + drift,
                    top: -8 - drift * 0.5,
                    child: Transform.rotate(
                      angle: math.sin(_float.value * math.pi * 2) * 0.08,
                      child: Icon(
                        Icons.backpack_rounded,
                        size: 88,
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BackpackerBadge(light: true),
                    const SizedBox(height: 12),
                    Text(
                      l10n.welcomeHello(name),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.appSubtitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.88),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const JourneyTrailBar(height: 3, width: double.infinity, light: true),
                    const SizedBox(height: 14),
                    if (widget.loading)
                      const BrandedLoadingIndicator(size: 28, color: Colors.white)
                    else if (widget.profile != null) ...[
                      Row(
                        children: [
                          _StatPill(
                            icon: Icons.monetization_on_outlined,
                            label: l10n.copperCoins,
                            value: '${widget.profile!.copperCoins}',
                          ),
                          const SizedBox(width: 10),
                          _StatPill(
                            icon: Icons.star_rounded,
                            label: l10n.reputation,
                            value: '${widget.profile!.reputationScore}',
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          l10n.flowStepCreate,
                          l10n.flowStepGive,
                          l10n.flowStepTake,
                          l10n.flowStepComplete,
                        ]
                            .map(
                              (step) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.14),
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
                                ),
                                child: Text(
                                  step,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _HeroAction(
                            icon: Icons.explore_outlined,
                            label: l10n.takeTaskAction,
                            filled: true,
                            onTap: widget.onTakeTasks,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _HeroAction(
                            icon: Icons.add_location_alt_outlined,
                            label: l10n.giveTaskAction,
                            filled: false,
                            onTap: widget.onCreateTask,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withValues(alpha: 0.24)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 14, color: Colors.white.withValues(alpha: 0.9)),
                    const SizedBox(width: 4),
                    Text(
                      label,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroAction extends StatelessWidget {
  const _HeroAction({
    required this.icon,
    required this.label,
    required this.filled,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool filled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: filled ? Colors.white : Colors.white.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: filled ? AppColors.trail : Colors.white,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: filled ? AppColors.trail : Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
