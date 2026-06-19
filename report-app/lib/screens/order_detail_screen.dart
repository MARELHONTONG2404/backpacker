import 'package:flutter/material.dart';

import '../models/order.dart';
import '../services/api_service.dart';
import '../services/auth_storage.dart';
import '../widgets/order_action_handler.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({
    super.key,
    required this.api,
    required this.orderId,
    this.initialOrder,
  });

  final ApiService api;
  final int orderId;
  final OrderItem? initialOrder;

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final _storage = AuthStorage();
  bool _loading = true;
  OrderItem? _order;
  int? _userId;

  @override
  void initState() {
    super.initState();
    _order = widget.initialOrder;
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      _userId ??= await _storage.getUserId();
      final order = await widget.api.fetchOrderDetail(widget.orderId);
      if (mounted) setState(() => _order = order);
    } on ApiException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message)));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = _order;
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Pesanan')),
      body: _loading && order == null
          ? const Center(child: CircularProgressIndicator())
          : order == null
              ? const Center(child: Text('Pesanan tidak ditemukan'))
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _StatusHeader(order: order),
                      const SizedBox(height: 16),
                      _InfoTile(label: 'Nomor', value: order.orderNo),
                      _InfoTile(label: 'Judul', value: order.title),
                      _InfoTile(label: 'Kategori', value: order.categoryLabel),
                      _InfoTile(label: 'Imbalan', value: 'Rp ${order.rewardAmount}'),
                      _InfoTile(label: 'Lokasi', value: order.locationText ?? '-'),
                      _InfoTile(label: 'Pembuat', value: order.creatorName ?? '-'),
                      _InfoTile(label: 'Pelaksana', value: order.executorName ?? 'Belum ada'),
                      if (order.roleLabel(_userId).isNotEmpty)
                        _InfoTile(label: 'Peran Anda', value: order.roleLabel(_userId)),
                      const SizedBox(height: 12),
                      Text('Deskripsi', style: Theme.of(context).textTheme.titleSmall),
                      const SizedBox(height: 4),
                      Text(order.description?.isNotEmpty == true ? order.description! : '-'),
                      if (order.cancelReason?.isNotEmpty == true) ...[
                        const SizedBox(height: 16),
                        _InfoTile(label: 'Alasan batal', value: order.cancelReason!),
                      ],
                      const SizedBox(height: 24),
                      OrderActionButtons(
                        order: order,
                        api: widget.api,
                        userId: _userId,
                        onChanged: _load,
                      ),
                    ],
                  ),
                ),
    );
  }
}

class _StatusHeader extends StatelessWidget {
  const _StatusHeader({required this.order});

  final OrderItem order;

  @override
  Widget build(BuildContext context) {
    final color = statusColor(order.status);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Status', style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 4),
          Text(
            order.statusLabel,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 110, child: Text(label, style: Theme.of(context).textTheme.bodySmall)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
