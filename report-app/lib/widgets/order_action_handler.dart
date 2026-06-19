import 'package:flutter/material.dart';

import '../models/order.dart';
import '../services/api_service.dart';

/// Menjalankan aksi lifecycle pesanan dengan dialog konfirmasi.
class OrderActionHandler {
  static Future<OrderItem?> run(
    BuildContext context, {
    required ApiService api,
    required OrderItem order,
    required OrderAction action,
  }) async {
    String? cancelReason;
    if (action.needsCancelReason) {
      cancelReason = await _askCancelReason(context);
      if (cancelReason == null) return null;
    } else {
      final confirmed = await _confirm(context, action);
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
          SnackBar(content: Text(_successMessage(action, updated))),
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

  static Future<bool> _confirm(BuildContext context, OrderAction action) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(action.label),
        content: Text(action.confirmMessage),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(action.label)),
        ],
      ),
    );
    return result ?? false;
  }

  static Future<String?> _askCancelReason(BuildContext context) async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Batalkan pesanan'),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Alasan pembatalan (opsional)',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Batalkan pesanan'),
          ),
        ],
      ),
    );
    controller.dispose();
    return result;
  }

  static String _successMessage(OrderAction action, OrderItem order) {
    switch (action) {
      case OrderAction.publish:
        return 'Tugas "${order.title}" dipublikasikan';
      case OrderAction.cancel:
        return 'Pesanan dibatalkan';
      case OrderAction.take:
        return 'Tugas "${order.title}" berhasil diambil';
      case OrderAction.start:
        return 'Tugas mulai dikerjakan';
      case OrderAction.complete:
        return 'Tugas selesai!';
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
    this.marketplace = false,
    this.compact = false,
  });

  final OrderItem order;
  final ApiService api;
  final int? userId;
  final VoidCallback onChanged;
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
        if (action.isPrimary) {
          return FilledButton(
            onPressed: () => _handle(context, action),
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
    final updated = await OrderActionHandler.run(context, api: api, order: order, action: action);
    if (updated != null) onChanged();
  }
}

Color statusColor(String status) {
  switch (status) {
    case 'DRAFT':
      return Colors.blueGrey;
    case 'PUBLISHED':
      return Colors.blue;
    case 'TAKEN':
      return Colors.orange;
    case 'IN_PROGRESS':
      return Colors.deepOrange;
    case 'COMPLETED':
      return Colors.green;
    case 'CANCELLED':
      return Colors.red;
    default:
      return Colors.grey;
  }
}
