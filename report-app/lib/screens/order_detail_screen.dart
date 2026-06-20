import 'package:flutter/material.dart';

import '../config/app_strings.dart';
import '../models/order.dart';
import '../services/api_service.dart';
import '../services/auth_storage.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
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
  int _ratingScore = 5;
  final _ratingCommentController = TextEditingController();
  bool _ratingLoading = false;

  @override
  void initState() {
    super.initState();
    _order = widget.initialOrder;
    _load();
  }

  @override
  void dispose() {
    _ratingCommentController.dispose();
    super.dispose();
  }

  Future<void> _submitRating() async {
    setState(() => _ratingLoading = true);
    try {
      final updated = await widget.api.rateOrder(
        widget.orderId,
        score: _ratingScore,
        comment: _ratingCommentController.text.trim(),
      );
      if (mounted) {
        setState(() => _order = updated);
        showAppMessage(context, AppStrings.rateSubmitted);
      }
    } on ApiException catch (error) {
      if (mounted) showAppMessage(context, error.message);
    } finally {
      if (mounted) setState(() => _ratingLoading = false);
    }
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      _userId ??= await _storage.getUserId();
      final order = await widget.api.fetchOrderDetail(widget.orderId);
      if (mounted) setState(() => _order = order);
    } on ApiException catch (error) {
      if (mounted) showAppMessage(context, error.message);
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
          ? const LoadingView(message: 'Memuat detail pesanan...')
          : order == null
              ? const EmptyState(
                  icon: Icons.error_outline,
                  title: 'Pesanan tidak ditemukan',
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _StatusHeader(order: order),
                      const SizedBox(height: 12),
                      SectionCard(
                        title: 'Informasi Tugas',
                        child: Column(
                          children: [
                            _InfoTile(label: 'Nomor', value: order.orderNo),
                            _InfoTile(label: 'Judul', value: order.title),
                            _InfoTile(label: 'Kategori', value: order.categoryLabel),
                            _InfoTile(label: 'Imbalan', value: 'Rp ${formatCurrency(order.rewardAmount)}'),
                            _InfoTile(label: 'Lokasi', value: order.locationText?.isNotEmpty == true ? order.locationText! : '-'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      SectionCard(
                        title: 'Pihak Terlibat',
                        child: Column(
                          children: [
                            _InfoTile(label: 'Pembuat', value: order.creatorName ?? '-'),
                            _InfoTile(label: 'Pelaksana', value: order.executorName ?? 'Belum ada'),
                            if (order.roleLabel(_userId).isNotEmpty)
                              _InfoTile(label: 'Peran Anda', value: order.roleLabel(_userId)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      SectionCard(
                        title: 'Deskripsi',
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            order.description?.isNotEmpty == true ? order.description! : '-',
                            style: const TextStyle(height: 1.5),
                          ),
                        ),
                      ),
                      if (order.cancelReason?.isNotEmpty == true) ...[
                        const SizedBox(height: 12),
                        SectionCard(
                          title: 'Alasan Batal',
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(order.cancelReason!),
                          ),
                        ),
                      ],
                      if (order.isRated) ...[
                        const SizedBox(height: 12),
                        SectionCard(
                          title: AppStrings.ratingLabel,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: List.generate(5, (index) {
                                  return Icon(
                                    index < (order.ratingScore ?? 0) ? Icons.star : Icons.star_border,
                                    color: AppColors.secondary,
                                  );
                                }),
                              ),
                              if (order.ratingComment?.isNotEmpty == true) ...[
                                const SizedBox(height: 8),
                                Text(order.ratingComment!),
                              ],
                            ],
                          ),
                        ),
                      ],
                      if (order.canRate(_userId)) ...[
                        const SizedBox(height: 12),
                        SectionCard(
                          title: AppStrings.rateTask,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(5, (index) {
                                  final score = index + 1;
                                  return IconButton(
                                    onPressed: _ratingLoading ? null : () => setState(() => _ratingScore = score),
                                    icon: Icon(
                                      score <= _ratingScore ? Icons.star : Icons.star_border,
                                      color: AppColors.secondary,
                                      size: 32,
                                    ),
                                  );
                                }),
                              ),
                              TextField(
                                controller: _ratingCommentController,
                                maxLines: 2,
                                decoration: const InputDecoration(
                                  labelText: 'Komentar (opsional)',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 12),
                              FilledButton(
                                onPressed: _ratingLoading ? null : _submitRating,
                                child: _ratingLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                      )
                                    : const Text('Kirim Penilaian'),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      OrderActionButtons(
                        order: order,
                        api: widget.api,
                        userId: _userId,
                        onChanged: _load,
                      ),
                      const SizedBox(height: 24),
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.16),
            color.withValues(alpha: 0.06),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(categoryIcon(order.category), color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                StatusBadge(label: order.statusLabel, status: order.status),
              ],
            ),
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
          SizedBox(
            width: 96,
            child: Text(
              label,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
