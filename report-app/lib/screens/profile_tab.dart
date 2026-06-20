import 'package:flutter/material.dart';

import '../config/app_strings.dart';
import '../models/backpacker_profile.dart';
import '../models/coin_transaction.dart';
import '../models/app_notification.dart';
import '../models/user_profile.dart';
import '../services/api_service.dart';
import '../services/auth_storage.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({
    super.key,
    required this.api,
    required this.coinProfile,
    required this.onProfileChanged,
    required this.onLogout,
  });

  final ApiService api;
  final BackpackerProfile? coinProfile;
  final VoidCallback onProfileChanged;
  final VoidCallback onLogout;

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final _storage = AuthStorage();
  UserProfile? _user;
  List<CoinTransaction> _transactions = [];
  List<AppNotification> _notifications = [];
  bool _loading = true;
  bool _checkinLoading = false;
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final user = await widget.api.fetchUserProfile();
      final tx = await widget.api.fetchCoinTransactions();
      final notifications = await widget.api.fetchNotifications();
      final unread = await widget.api.fetchUnreadNotificationCount();
      if (mounted) {
        setState(() {
          _user = user;
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
    if (widget.coinProfile != null && !widget.coinProfile!.canCheckinToday) return;
    setState(() => _checkinLoading = true);
    try {
      await widget.api.dailyCheckin();
      widget.onProfileChanged();
      await _load();
      if (mounted) {
        showAppMessage(context, 'Check-in berhasil! +${widget.coinProfile?.dailyCheckinReward ?? 2} koin');
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

    final profile = widget.coinProfile;
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
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
          const SizedBox(height: 12),
          SectionCard(
            title: AppStrings.copperCoins,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${profile?.copperCoins ?? 0}', style: Theme.of(context).textTheme.headlineSmall),
                      Text('Reputasi: ${profile?.reputationScore ?? 0}', style: Theme.of(context).textTheme.bodyMedium),
                      if (profile?.completedTasks != null)
                        Text('Tugas selesai: ${profile!.completedTasks}', style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
                FilledButton(
                  onPressed: (profile?.canCheckinToday ?? false) && !_checkinLoading ? _checkin : null,
                  child: _checkinLoading
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(profile?.canCheckinToday ?? false ? AppStrings.checkin : AppStrings.checkinDone),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SectionCard(
            title: 'Riwayat Koin',
            child: _transactions.isEmpty
                ? const Text('Belum ada transaksi')
                : Column(
                    children: _transactions.take(10).map((tx) {
                      final sign = tx.amount >= 0 ? '+' : '';
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(tx.remark ?? tx.txType),
                        subtitle: Text(tx.createTime ?? ''),
                        trailing: Text(
                          '$sign${tx.amount}',
                          style: TextStyle(
                            color: tx.amount >= 0 ? AppColors.secondary : Theme.of(context).colorScheme.error,
                            fontWeight: FontWeight.w600,
                          ),
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
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        n.isRead ? Icons.notifications_none : Icons.notifications_active,
                        color: n.isRead ? AppColors.textSecondary : AppColors.primary,
                      ),
                      title: Text(n.title, style: TextStyle(fontWeight: n.isRead ? FontWeight.normal : FontWeight.w600)),
                      subtitle: Text('${n.content}\n${n.createTime ?? ''}'),
                      isThreeLine: true,
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
