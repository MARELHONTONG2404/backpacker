import 'package:flutter/material.dart';

import '../models/backpacker_profile.dart';
import '../models/order.dart';
import '../services/api_service.dart';

/// Menjalankan aksi lifecycle pesanan dengan dialog konfirmasi.
class OrderActionHandler {
  static Future<OrderItem?> run(
    BuildContext context, {
    required ApiService api,
    required OrderItem order,
    required OrderAction action,
    BackpackerProfile? profile,
  }) async {
    if (action == OrderAction.take && profile != null && !profile.canTakeTask) {
      await _showLowReputationDialog(context, profile);
      return null;
    }

    if (action == OrderAction.publish &&
        profile != null &&
        !profile.canAffordPublish) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(profile.publishBlockedMessage)),
        );
      }
      return null;
    }

    String? cancelReason;
    if (action.needsCancelReason) {
      cancelReason = await _askCancelReason(context, action);
      if (cancelReason == null) return null;
    } else {
      final confirmed = await _confirm(context, action, profile);
      if (!confirmed) return null;
    }

    try {
      final updated = await api.takeOrderAction(
        order.orderId,
        action.apiKey,
        cancelReason: cancelReason,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_successMessage(action, updated, profile))),
        );
      }
      return updated;
    } on ApiException catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message)),
        );
      }
      return null;
    }
  }

  static Future<void> _showLowReputationDialog(
    BuildContext context,
    BackpackerProfile profile,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reputasi Terlalu Rendah'),
        content: Text(profile.reputationBlockedMessage),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Mengerti'),
          ),
        ],
      ),
    );
  }

  static Future<bool> _confirm(
    BuildContext context,
    OrderAction action,
    BackpackerProfile? profile,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(action.label),
        content: Text(action.message(profile)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(action.label)),
        ],
      ),
    );
    return result ?? false;
  }

  static Future<String?> _askCancelReason(BuildContext context, OrderAction action) async {
    final controller = TextEditingController();
    final isAbandon = action == OrderAction.abandon;
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isAbandon ? 'Lepas tugas' : 'Batalkan pesanan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isAbandon)
              const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  'Melepas tugas akan menurunkan reputasi Anda.',
                  style: TextStyle(fontSize: 13),
                ),
              ),
            TextField(
              controller: controller,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: isAbandon ? 'Alasan melepas tugas (opsional)' : 'Alasan pembatalan (opsional)',
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: Text(isAbandon ? 'Lepas tugas' : 'Batalkan pesanan'),
          ),
        ],
      ),
    );
    controller.dispose();
    return result;
  }

  static String _successMessage(
    OrderAction action,
    OrderItem order,
    BackpackerProfile? profile,
  ) {
    switch (action) {
      case OrderAction.publish:
        return 'Tugas "${order.title}" dipublikasikan (-${profile?.publishFee ?? 5} koin)';
      case OrderAction.cancel:
        return 'Pesanan dibatalkan';
      case OrderAction.take:
        return 'Tugas "${order.title}" berhasil diambil';
      case OrderAction.start:
        return 'Tugas mulai dikerjakan';
      case OrderAction.complete:
        return 'Tugas selesai! +${profile?.taskRewardCoins ?? 3} koin, +${profile?.reputationTaskComplete ?? 5} reputasi';
      case OrderAction.abandon:
        return 'Tugas dilepas. Reputasi berkurang.';
    }
  }
}

/// Tombol aksi lifecycle untuk satu pesanan.
class OrderActionButtons extends StatelessWidget {
  const OrderActionButtons({
    super.key,
    required this.order,
    required this.api,
    required this.userId,
    required this.onChanged,
    this.profile,
    this.marketplace = false,
    this.compact = false,
  });

  final OrderItem order;
  final ApiService api;
  final int? userId;
  final VoidCallback onChanged;
  final BackpackerProfile? profile;
  final bool marketplace;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final actions = order.availableActions(userId, marketplace: marketplace);
    if (actions.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: actions.map((action) {
        final blockedTake = action == OrderAction.take &&
            profile != null &&
            !profile!.canTakeTask;

        if (action.isPrimary) {
          return FilledButton(
            style: blockedTake
                ? FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.errorContainer,
                    foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
                  )
                : null,
            onPressed: blockedTake
                ? () => OrderActionHandler.run(
                      context,
                      api: api,
                      order: order,
                      action: action,
                      profile: profile,
                    )
                : () => _handle(context, action),
            child: Text(compact ? action.label : action.label),
          );
        }
        return OutlinedButton(
          onPressed: () => _handle(context, action),
          child: Text(action.label),
        );
      }).toList(),
    );
  }

  Future<void> _handle(BuildContext context, OrderAction action) async {
    final updated = await OrderActionHandler.run(
      context,
      api: api,
      order: order,
      action: action,
      profile: profile,
    );
    if (updated != null) onChanged();
  }
}
