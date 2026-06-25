import 'package:flutter/material.dart';

import '../l10n/l10n_extension.dart';
import '../models/order.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import 'common_widgets.dart';

/// Bottom sheet penilaian tugas oleh pembuat setelah pelaksana menyelesaikan.
Future<OrderItem?> showRateOrderSheet(
  BuildContext context, {
  required ApiService api,
  required OrderItem order,
}) {
  return showModalBottomSheet<OrderItem>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => _RateOrderSheetBody(api: api, order: order),
  );
}

class _RateOrderSheetBody extends StatefulWidget {
  const _RateOrderSheetBody({required this.api, required this.order});

  final ApiService api;
  final OrderItem order;

  @override
  State<_RateOrderSheetBody> createState() => _RateOrderSheetBodyState();
}

class _RateOrderSheetBodyState extends State<_RateOrderSheetBody> {
  int _ratingScore = 5;
  final _commentController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _loading = true);
    try {
      final updated = await widget.api.rateOrder(
        widget.order.orderId,
        score: _ratingScore,
        comment: _commentController.text.trim(),
      );
      if (mounted) {
        showAppMessage(context, context.l10n.rateSubmitted);
        Navigator.pop(context, updated);
      }
    } on ApiException catch (error) {
      if (mounted) showLocalizedAppMessage(context, error.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.rateTask,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            widget.order.title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          if (widget.order.executorName?.isNotEmpty == true) ...[
            const SizedBox(height: 4),
            Text(
              '${l10n.executor}: ${widget.order.executorName}',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ],
          const SizedBox(height: 12),
          Text(l10n.ratePrompt, style: const TextStyle(height: 1.4)),
          const SizedBox(height: 4),
          Text(
            l10n.rateExecutorHint,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final score = index + 1;
              return IconButton(
                onPressed: _loading ? null : () => setState(() => _ratingScore = score),
                icon: Icon(
                  score <= _ratingScore ? Icons.star : Icons.star_border,
                  color: AppColors.secondary,
                  size: 36,
                ),
              );
            }),
          ),
          TextField(
            controller: _commentController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: l10n.commentOptional,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _loading ? null : _submit,
            child: _loading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : Text(l10n.submitRating),
          ),
        ],
      ),
    );
  }
}
