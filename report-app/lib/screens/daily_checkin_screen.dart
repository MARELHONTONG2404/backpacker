import 'package:flutter/material.dart';

import '../l10n/l10n_extension.dart';
import '../l10n/server_message_localizer.dart';
import '../navigation/auth_navigation.dart';
import '../models/backpacker_profile.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_animations.dart';
import '../widgets/auth_background.dart';
import '../widgets/backpacker_brand.dart';
import '../widgets/common_widgets.dart';
import '../widgets/glass_surface.dart';
import 'home_screen.dart';

/// Layar check-in harian setelah login.
class DailyCheckinScreen extends StatefulWidget {
  const DailyCheckinScreen({super.key, required this.api});

  final ApiService api;

  @override
  State<DailyCheckinScreen> createState() => _DailyCheckinScreenState();
}

class _DailyCheckinScreenState extends State<DailyCheckinScreen> {
  BackpackerProfile? _profile;
  bool _loading = true;
  bool _checkinLoading = false;
  bool _checkinSuccess = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    try {
      final profile = await widget.api.fetchCoinProfile();
      if (!mounted) return;
      setState(() {
        _profile = profile;
        _loading = false;
      });
    } on ApiException catch (error) {
      if (!mounted) return;
      if (error.unauthorized) {
        await redirectToLoginIfUnauthorized(context, widget.api, error);
        return;
      }
      setState(() {
        _loading = false;
        _errorMessage = error.message;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _errorMessage = localizeServerMessage(context.l10n, '$error');
      });
    }
  }

  Future<void> _checkin() async {
    final profile = _profile;
    if (profile == null || !profile.canCheckinToday || _checkinLoading) return;

    setState(() => _checkinLoading = true);
    try {
      final updated = await widget.api.dailyCheckin();
      if (!mounted) return;
      setState(() {
        _profile = updated;
        _checkinSuccess = true;
        _checkinLoading = false;
      });
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() => _checkinLoading = false);
      showLocalizedAppMessage(context, error.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _checkinLoading = false);
      showAppMessage(context, context.l10n.serverConnectFailed);
    }
  }

  void _goHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => HomeScreen(api: widget.api)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final profile = _profile;
    final reward = profile?.dailyCheckinReward ?? 5;
    final canCheckin = profile?.canCheckinToday ?? false;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const AuthBackground(),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.adventureDark.withValues(alpha: 0.35),
                  Colors.black.withValues(alpha: 0.5),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: EntranceFadeSlide(
                  duration: const Duration(milliseconds: 520),
                  offsetY: 24,
                  child: GlassSurface(
                    blur: true,
                    opacity: 0.92,
                    borderRadius: 20,
                    elevation: 2,
                    padding: const EdgeInsets.fromLTRB(25, 28, 25, 24),
                    child: SizedBox(
                      width: MediaQuery.sizeOf(context).width > 448
                          ? 400
                          : MediaQuery.sizeOf(context).width - 48,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Center(
                            child: BackpackerBrandTitle(showLogo: true, showSubtitle: false),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            l10n.checkinScreenTitle,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.checkinScreenSubtitle(reward),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                  height: 1.45,
                                ),
                          ),
                          const SizedBox(height: 24),
                          if (_loading)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 32),
                              child: Center(child: BrandedLoadingIndicator(size: 36)),
                            )
                          else if (_errorMessage != null)
                            _ErrorState(
                              message: localizeServerMessage(l10n, _errorMessage!),
                              onRetry: _loadProfile,
                            )
                          else if (_checkinSuccess || !canCheckin)
                            _DoneState(
                              profile: profile!,
                              justCheckedIn: _checkinSuccess,
                              onContinue: _goHome,
                            )
                          else
                            _CheckinAction(
                              reward: reward,
                              loading: _checkinLoading,
                              onCheckin: _checkin,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckinAction extends StatelessWidget {
  const _CheckinAction({
    required this.reward,
    required this.loading,
    required this.onCheckin,
  });

  final int reward;
  final bool loading;
  final VoidCallback onCheckin;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.brandGradient,
            boxShadow: AppDecorations.cardShadow(elevation: 0.6),
          ),
          alignment: Alignment.center,
          child: const Icon(Icons.calendar_today_rounded, color: Colors.white, size: 40),
        ),
        const SizedBox(height: 20),
        Text(
          l10n.checkinScreenPrompt,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.45),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 44,
          child: FilledButton.icon(
            onPressed: loading ? null : onCheckin,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            icon: loading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.check_circle_outline),
            label: Text(loading ? l10n.submitting : l10n.checkinScreenAction),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.checkinScreenRewardHint(reward),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _DoneState extends StatelessWidget {
  const _DoneState({
    required this.profile,
    required this.justCheckedIn,
    required this.onContinue,
  });

  final BackpackerProfile profile;
  final bool justCheckedIn;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        Icon(
          justCheckedIn ? Icons.celebration_outlined : Icons.check_circle_outline,
          size: 64,
          color: justCheckedIn ? AppColors.secondary : AppColors.primary,
        ),
        const SizedBox(height: 16),
        Text(
          justCheckedIn
              ? l10n.checkinSuccess(profile.dailyCheckinReward)
              : l10n.checkinDone,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Text(
          justCheckedIn ? l10n.checkinScreenSuccessHint : l10n.checkinScreenAlreadyDone,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                height: 1.45,
              ),
        ),
        const SizedBox(height: 12),
        Text(
          '${l10n.copperCoins}: ${profile.copperCoins}',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 44,
          child: FilledButton(
            onPressed: onContinue,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.checkinContinueHome),
          ),
        ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.error),
        const SizedBox(height: 12),
        Text(message, textAlign: TextAlign.center),
        const SizedBox(height: 16),
        OutlinedButton(onPressed: onRetry, child: Text(l10n.retry)),
      ],
    );
  }
}
