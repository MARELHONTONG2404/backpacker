import 'package:flutter/material.dart';

import '../models/backpacker_profile.dart';
import '../models/coin_transaction.dart';
import '../models/app_notification.dart';
import '../models/user_profile.dart';
import '../services/api_service.dart';
import '../services/auth_storage.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/gamification_banner.dart';

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
  bool _checkinLoading = false;
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
        _coinError = 'Gagal memuat koin: $error';
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
      if (mounted) showAppMessage(context, error.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _checkin() async {
    if (_coinProfile != null && !_coinProfile!.canCheckinToday) return;
    setState(() => _checkinLoading = true);
    try {
      await widget.api.dailyCheckin();
      widget.onProfileChanged();
      await _load();
      if (mounted) {
        showAppMessage(context, 'Check-in berhasil! +${_coinProfile?.dailyCheckinReward ?? 2} koin');
      }
    } on ApiException catch (error) {
      if (mounted) showAppMessage(context, error.message);
    } finally {
      if (mounted) setState(() => _checkinLoading = false);
    }
  }

  Future<void> _editProfile() async {
    final nickController = TextEditingController(text: _user?.nickName ?? '');
    final phoneController = TextEditingController(text: _user?.phonenumber ?? '');
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Profil'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nickController,
              decoration: const InputDecoration(labelText: 'Nama tampilan'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Nomor telepon'),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Simpan')),
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
      if (mounted) showAppMessage(context, 'Profil berhasil diperbarui');
    } on ApiException catch (error) {
      if (mounted) showAppMessage(context, error.message);
    }
  }

  Future<void> _markAllRead() async {
    try {
      await widget.api.markAllNotificationsRead();
      await _load();
    } on ApiException catch (error) {
      if (mounted) showAppMessage(context, error.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const LoadingView(message: 'Memuat profil...');
    }

    final profile = _coinProfile;
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          GamificationBanner(
            profile: profile,
            errorMessage: _coinError,
            checkinLoading: _checkinLoading,
            onCheckin: _checkin,
            onRetry: _load,
          ),
          const SizedBox(height: 12),
          SectionCard(
            title: 'Akun Saya',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_user?.nickName ?? '-', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text('@${_user?.username ?? '-'}', style: Theme.of(context).textTheme.bodySmall),
                if (_user?.phonenumber?.isNotEmpty == true) ...[
                  const SizedBox(height: 4),
                  Text(_user!.phonenumber!, style: Theme.of(context).textTheme.bodySmall),
                ],
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _editProfile,
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('Edit Profil'),
                ),
              ],
            ),
          ),
          if (profile != null) ...[
            const SizedBox(height: 12),
            SectionCard(
              title: 'Statistik',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Biaya publikasi: ${profile.publishFee} koin'),
                  Text('Reward selesai tugas: +${profile.taskRewardCoins ?? 3} koin'),
                  Text('Reputasi per tugas: +${profile.reputationTaskComplete ?? 5} poin'),
                  if (profile.completedTasks != null) Text('Tugas selesai: ${profile.completedTasks}'),
                  if (profile.lastCheckinDate != null)
                    Text('Check-in terakhir: ${profile.lastCheckinDate}'),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          SectionCard(
            title: 'Riwayat Koin',
            child: _transactions.isEmpty
                ? const Text('Belum ada transaksi')
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
                                  Text(tx.remark ?? tx.txType, style: const TextStyle(fontWeight: FontWeight.w600)),
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
          ),
          const SizedBox(height: 12),
          SectionCard(
            title: 'Notifikasi',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_unreadCount > 0)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(onPressed: _markAllRead, child: Text('Tandai dibaca ($_unreadCount)')),
                  ),
                if (_notifications.isEmpty)
                  const Text('Belum ada notifikasi')
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
                                  n.title,
                                  style: TextStyle(fontWeight: n.isRead ? FontWeight.normal : FontWeight.w600),
                                ),
                                const SizedBox(height: 4),
                                Text('${n.content}\n${n.createTime ?? ''}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: widget.onLogout,
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Keluar'),
          ),
        ],
      ),
    );
  }
}
