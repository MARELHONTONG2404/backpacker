import 'package:flutter/material.dart';

import '../l10n/l10n_extension.dart';
import '../models/backpacker_profile.dart';
import '../models/coin_transaction.dart';
import '../models/app_notification.dart';
import '../models/user_profile.dart';
import '../services/api_service.dart';
import '../services/auth_storage.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/gamification_banner.dart';
import '../widgets/language_selector.dart';
import '../widgets/theme_selector.dart';
import '../app/app_locale_scope.dart';
import '../l10n/server_message_localizer.dart';
import '../widgets/layout/tab_context_header.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({
    super.key,
    required this.api,
    required this.onProfileChanged,
    required this.onLogout,
  });

  final ApiService api;
  final VoidCallback onProfileChanged;
  final VoidCallback onLogout;

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final _storage = AuthStorage();
  UserProfile? _user;
  BackpackerProfile? _coinProfile;
  List<CoinTransaction> _transactions = [];
  List<AppNotification> _notifications = [];
  bool _loading = true;
  String? _coinError;
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _coinError = null;
    });
    try {
      final user = await widget.api.fetchUserProfile();
      BackpackerProfile? coins;
      try {
        coins = await widget.api.fetchCoinProfile();
      } on ApiException catch (error) {
        _coinError = error.message;
      } catch (error) {
        if (mounted) {
          _coinError = context.l10n.loadCoinsProfileFailed(
            localizeServerMessage(context.l10n, '$error'),
          );
        }
      }

      List<CoinTransaction> tx = [];
      try {
        tx = await widget.api.fetchCoinTransactions();
      } catch (_) {}

      List<AppNotification> notifications = [];
      var unread = 0;
      try {
        notifications = await widget.api.fetchNotifications();
        unread = await widget.api.fetchUnreadNotificationCount();
      } catch (_) {}

      if (mounted) {
        setState(() {
          _user = user;
          _coinProfile = coins;
          _transactions = tx;
          _notifications = notifications;
          _unreadCount = unread;
        });
      }
    } on ApiException catch (error) {
      if (mounted) showLocalizedAppMessage(context, error.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _editProfile() async {
    final l10n = context.l10n;
    final nickController = TextEditingController(text: _user?.nickName ?? '');
    final phoneController = TextEditingController(text: _user?.phonenumber ?? '');
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.editProfile),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nickController,
              decoration: InputDecoration(labelText: l10n.displayName),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: l10n.phoneNumber),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.save)),
        ],
      ),
    );
    if (saved != true || !mounted) return;
    try {
      final updated = await widget.api.updateProfile(
        nickName: nickController.text.trim(),
        phonenumber: phoneController.text.trim(),
      );
      await _storage.updateNickName(updated.nickName);
      widget.onProfileChanged();
      await _load();
      if (mounted) showAppMessage(context, context.l10n.profileUpdated);
    } on ApiException catch (error) {
      if (mounted) showLocalizedAppMessage(context, error.message);
    }
  }

  Future<void> _markAllRead() async {
    try {
      await widget.api.markAllNotificationsRead();
      await _load();
    } on ApiException catch (error) {
      if (mounted) showLocalizedAppMessage(context, error.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (_loading) {
      return LoadingView(message: l10n.loadingProfile);
    }

    final profile = _coinProfile;
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppLayout.screenPadding),
        children: [
          TabContextHeader(
            title: l10n.tabProfile,
            subtitle: l10n.appConcept,
            icon: Icons.person_outline,
            color: AppColors.primary,
            embedded: true,
          ),
          const SizedBox(height: AppLayout.sectionGap),
          _ProfileHeader(
            nickName: _user?.nickName,
            username: _user?.username,
            phone: _user?.phonenumber,
          ),
          const SizedBox(height: AppLayout.sectionGap),
          GamificationBanner(
            profile: profile,
            style: GamificationBannerStyle.compact,
            embedded: true,
            errorMessage: _coinError,
            onRetry: _load,
          ),
          const SizedBox(height: AppLayout.sectionGap),
          SectionCard(
            title: l10n.myAccount,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_user?.phonenumber?.isNotEmpty == true)
                  Text(_user!.phonenumber!, style: Theme.of(context).textTheme.bodySmall),
                if (_user?.phonenumber?.isNotEmpty == true) const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _editProfile,
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: Text(l10n.editProfile),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SectionCard(
            title: l10n.language,
            child: const LanguageSelector(),
          ),
          const SizedBox(height: 12),
          SectionCard(
            title: l10n.appearance,
            child: const ThemeSelector(),
          ),
          if (profile != null) ...[
            const SizedBox(height: 12),
            SectionCard(
              title: l10n.statistics,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.publishFeeStat(profile.publishFee)),
                  Text(l10n.taskRewardStat(profile.taskRewardCoins ?? 3)),
                  Text(l10n.reputationPerTask(profile.reputationTaskComplete ?? 5)),
                  if (profile.completedTasks != null)
                    Text(l10n.completedTasksStat(profile.completedTasks!)),
                  if (profile.lastCheckinDate != null)
                    Text(l10n.lastCheckinStat(profile.lastCheckinDate!)),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          ListenableBuilder(
            listenable: AppLocaleScope.of(context),
            builder: (context, _) {
              final l10n = context.l10n;
              return SectionCard(
                title: l10n.coinHistory,
                child: _transactions.isEmpty
                    ? Text(l10n.noTransactions)
                    : Column(
                        children: _transactions.take(10).map((tx) {
                          final sign = tx.amount >= 0 ? '+' : '';
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        localizeCoinRemark(l10n, tx.remark, tx.txType),
                                        style: const TextStyle(fontWeight: FontWeight.w600),
                                      ),
                                      if (tx.createTime != null)
                                        Text(tx.createTime!, style: Theme.of(context).textTheme.bodySmall),
                                    ],
                                  ),
                                ),
                                Text(
                                  '$sign${tx.amount}',
                                  style: TextStyle(
                                    color: tx.amount >= 0 ? AppColors.secondary : Theme.of(context).colorScheme.error,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
              );
            },
          ),
          const SizedBox(height: 12),
          ListenableBuilder(
            listenable: AppLocaleScope.of(context),
            builder: (context, _) {
              final l10n = context.l10n;
              return SectionCard(
                title: l10n.notifications,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_unreadCount > 0)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _markAllRead,
                          child: Text(l10n.markRead(_unreadCount)),
                        ),
                      ),
                    if (_notifications.isEmpty)
                      Text(l10n.noNotifications)
                    else
                      ..._notifications.take(10).map((n) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                n.isRead ? Icons.notifications_none : Icons.notifications_active,
                                color: n.isRead ? AppColors.textSecondary : AppColors.primary,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      localizeNotificationTitle(l10n, n),
                                      style: TextStyle(fontWeight: n.isRead ? FontWeight.normal : FontWeight.w600),
                                    ),
                                    const SizedBox(height: 4),
                                    Text('${localizeNotificationContent(l10n, n)}\n${n.createTime ?? ''}'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: AppLayout.sectionGap),
          OutlinedButton.icon(
            onPressed: widget.onLogout,
            icon: const Icon(Icons.logout_rounded),
            label: Text(l10n.logout),
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
              side: BorderSide(color: Theme.of(context).colorScheme.error.withValues(alpha: 0.4)),
            ),
          ),
          const SizedBox(height: AppLayout.listBottomInset),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    this.nickName,
    this.username,
    this.phone,
  });

  final String? nickName;
  final String? username;
  final String? phone;

  @override
  Widget build(BuildContext context) {
    final displayName = nickName?.trim().isNotEmpty == true ? nickName! : (username ?? '-');
    final initials = displayName.isNotEmpty ? displayName.characters.first.toUpperCase() : '?';

    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: AppColors.brandGradient,
            shape: BoxShape.circle,
            boxShadow: AppDecorations.cardShadow(elevation: 0.4),
          ),
          alignment: Alignment.center,
          child: Text(
            initials,
            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 2),
              Text('@${username ?? '-'}', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}
