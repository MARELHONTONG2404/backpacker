import 'package:flutter/material.dart';

import '../l10n/l10n_extension.dart';
import '../models/backpacker_profile.dart';
import '../models/order.dart';
import '../services/api_service.dart';
import '../services/auth_storage.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/order_action_handler.dart';
import 'order_chat_screen.dart';

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
  BackpackerProfile? _coinProfile;
  int _ratingScore = 5;
  final _ratingCommentController = TextEditingController();
  bool _ratingLoading = false;
  int _chatUnreadCount = 0;

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
        showAppMessage(context, context.l10n.rateSubmitted);
      }
    } on ApiException catch (error) {
      if (mounted) showLocalizedAppMessage(context, error.message);
    } finally {
      if (mounted) setState(() => _ratingLoading = false);
    }
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      _userId ??= await _storage.getUserId();
      if (_userId == null) {
        try {
          final profile = await widget.api.fetchUserProfile();
          _userId = profile.userId;
        } catch (_) {}
      }
      final order = await widget.api.fetchOrderDetail(widget.orderId);
      BackpackerProfile? profile;
      try {
        profile = await widget.api.fetchCoinProfile();
      } catch (_) {}
      var chatUnread = 0;
      if (order.canChat(_userId)) {
        try {
          chatUnread = await widget.api.fetchOrderChatUnreadCount(widget.orderId);
        } catch (_) {}
      }
      if (mounted) {
        setState(() {
          _order = order;
          _coinProfile = profile;
          _chatUnreadCount = chatUnread;
        });
      }
    } on ApiException catch (error) {
      if (mounted) showLocalizedAppMessage(context, error.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openChat(OrderItem order) async {
    if (_userId == null) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => OrderChatScreen(
          api: widget.api,
          order: order,
          userId: _userId!,
        ),
      ),
    );
    if (mounted) _load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final order = _order;
    final showChat = order?.canChat(_userId) ?? false;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.orderDetail),
        actions: [
          if (showChat)
            IconButton(
              tooltip: l10n.openChat,
              onPressed: order == null ? null : () => _openChat(order),
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.chat_bubble_outline),
                  if (_chatUnreadCount > 0)
                    Positioned(
                      right: -4,
                      top: -4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.error,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          '$_chatUnreadCount',
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
      body: _loading && order == null
          ? LoadingView(message: l10n.loadingOrderDetail)
          : order == null
              ? EmptyState(
                  icon: Icons.error_outline,
                  title: l10n.orderNotFound,
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    children: [
                      _StatusHeader(order: order),
                      const SizedBox(height: 12),
                      SectionCard(
                        title: l10n.taskInfo,
                        child: Column(
                          children: [
                            _InfoTile(label: l10n.orderNumber, value: order.orderNo),
                            _InfoTile(label: l10n.title, value: order.title),
                            _InfoTile(label: l10n.category, value: order.categoryLabel(l10n)),
                            _InfoTile(
                              label: l10n.reward,
                              value: l10n.rewardAmountValue(formatCurrency(order.rewardAmount)),
                            ),
                            _InfoTile(
                              label: l10n.location,
                              value: order.locationText?.isNotEmpty == true ? order.locationText! : '-',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      SectionCard(
                        title: l10n.involvedParties,
                        child: Column(
                          children: [
                            _InfoTile(label: l10n.creator, value: order.creatorName ?? '-'),
                            _InfoTile(label: l10n.executor, value: order.executorName ?? l10n.noExecutorYet),
                            if (order.roleLabel(l10n, _userId).isNotEmpty)
                              _InfoTile(label: l10n.yourRole, value: order.roleLabel(l10n, _userId)),
                          ],
                        ),
                      ),
                      if (order.isParticipant(_userId)) ...[
                        const SizedBox(height: 12),
                        SectionCard(
                          title: l10n.chatSectionTitle,
                          child: order.canChat(_userId)
                              ? SizedBox(
                                  width: double.infinity,
                                  child: FilledButton(
                                    onPressed: _userId == null ? null : () => _openChat(order),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.chat_bubble_outline),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: Text(
                                            l10n.openChat,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        if (_chatUnreadCount > 0) ...[
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withValues(alpha: 0.22),
                                              borderRadius: BorderRadius.circular(999),
                                            ),
                                            child: Text(
                                              '$_chatUnreadCount',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                )
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.info_outline, size: 20, color: AppColors.textSecondary),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        order.chatUnavailableReason(l10n) ?? l10n.chatUnavailablePublished,
                                        style: const TextStyle(height: 1.4, color: AppColors.textSecondary),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      SectionCard(
                        title: l10n.description,
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
                          title: l10n.cancelReason,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(order.cancelReason!),
                          ),
                        ),
                      ],
                      if (order.isRated) ...[
                        const SizedBox(height: 12),
                        SectionCard(
                          title: l10n.ratingLabel,
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
                          title: l10n.rateTask,
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
                                decoration: InputDecoration(
                                  labelText: l10n.commentOptional,
                                  border: const OutlineInputBorder(),
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
                                    : Text(l10n.submitRating),
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
                        profile: _coinProfile,
                        myOrders: true,
                        fullWidth: true,
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
    final l10n = context.l10n;
    final color = statusColor(order.status, brightness: Theme.of(context).brightness);
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
                StatusBadge(label: order.statusLabel(l10n), status: order.status),
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
