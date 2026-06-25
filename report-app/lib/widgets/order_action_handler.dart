import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../l10n/l10n_extension.dart';
import '../l10n/server_message_localizer.dart';
import '../models/backpacker_profile.dart';
import '../models/order.dart';
import '../services/api_service.dart';
import 'common_widgets.dart';

/// Menjalankan aksi lifecycle pesanan dengan dialog konfirmasi.
class OrderActionHandler {
  static Future<OrderItem?> run(
    BuildContext context, {
    required ApiService api,
    required OrderItem order,
    required OrderAction action,
    BackpackerProfile? profile,
  }) async {
    final l10n = context.l10n;

    if (action == OrderAction.take && profile != null && !profile.canTakeTask) {
      await _showLowReputationDialog(context, profile);
      return null;
    }

    if (action == OrderAction.publish &&
        profile != null &&
        !profile.canAffordPublish) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(profile.publishBlockedMessage(l10n))),
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
      var workingOrder = order;
      if (action == OrderAction.submit && workingOrder.status == 'TAKEN') {
        workingOrder = await api.takeOrderAction(workingOrder.orderId, 'start');
      }
      final updated = await api.takeOrderAction(
        workingOrder.orderId,
        action.apiKey,
        cancelReason: cancelReason,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_successMessage(l10n, action, updated, profile))),
        );
      }
      return updated;
    } on ApiException catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizeServerMessage(l10n, error.message))),
        );
      }
      return null;
    }
  }

  static Future<void> _showLowReputationDialog(
    BuildContext context,
    BackpackerProfile profile,
  ) async {
    final l10n = context.l10n;
    await showAppInfoDialog(
      context,
      title: l10n.lowReputationTitle,
      message: profile.reputationBlockedMessage(l10n),
      actionLabel: l10n.understand,
    );
  }

  static Future<bool> _confirm(
    BuildContext context,
    OrderAction action,
    BackpackerProfile? profile,
  ) {
    final l10n = context.l10n;
    return showAppConfirmDialog(
      context,
      title: action.label(l10n),
      message: action.message(l10n, profile),
      confirmLabel: action.label(l10n),
      cancelLabel: l10n.cancel,
    );
  }

  static Future<String?> _askCancelReason(BuildContext context, OrderAction action) {
    final l10n = context.l10n;
    final isAbandon = action == OrderAction.abandon;
    return showAppInputDialog(
      context,
      title: isAbandon ? l10n.abandonTask : l10n.cancelOrder,
      warning: isAbandon ? l10n.abandonWarning : null,
      hint: isAbandon ? l10n.abandonReasonOptional : l10n.cancelReasonOptional,
      confirmLabel: isAbandon ? l10n.abandonTask : l10n.cancelOrder,
      cancelLabel: l10n.cancel,
    );
  }

  static String _successMessage(
    AppLocalizations l10n,
    OrderAction action,
    OrderItem order,
    BackpackerProfile? profile,
  ) {
    switch (action) {
      case OrderAction.publish:
        return l10n.successPublished(order.title, profile?.publishFee ?? 5);
      case OrderAction.cancel:
        return l10n.successCancelled;
      case OrderAction.take:
        return l10n.successTaken(order.title);
      case OrderAction.start:
        return l10n.successStarted;
      case OrderAction.submit:
        return l10n.successSubmitted;
      case OrderAction.confirm:
        return l10n.successConfirmed;
      case OrderAction.abandon:
        return l10n.successAbandoned;
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
    this.myOrders = false,
    this.compact = false,
    this.fullWidth = false,
  });

  final OrderItem order;
  final ApiService api;
  final int? userId;
  final VoidCallback onChanged;
  final BackpackerProfile? profile;
  final bool marketplace;
  final bool myOrders;
  final bool compact;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final actions = order.availableActions(
      userId,
      marketplace: marketplace,
      myOrders: myOrders,
    );
    if (actions.isEmpty) return const SizedBox.shrink();

    Widget buildButton(OrderAction action) {
      final blockedTake = action == OrderAction.take &&
          profile != null &&
          !profile!.canTakeTask;

      if (action.isPrimary) {
        final button = FilledButton(
          style: FilledButton.styleFrom(
            minimumSize: fullWidth ? const Size.fromHeight(44) : null,
            backgroundColor: blockedTake
                ? Theme.of(context).colorScheme.errorContainer
                : null,
            foregroundColor: blockedTake
                ? Theme.of(context).colorScheme.onErrorContainer
                : null,
          ),
          onPressed: blockedTake
              ? () => OrderActionHandler.run(
                    context,
                    api: api,
                    order: order,
                    action: action,
                    profile: profile,
                  )
              : () => _handle(context, action),
          child: Text(action.label(l10n)),
        );
        return fullWidth ? SizedBox(width: double.infinity, child: button) : button;
      }

      final button = OutlinedButton(
        style: fullWidth
            ? OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(44))
            : null,
        onPressed: () => _handle(context, action),
        child: Text(action.label(l10n)),
      );
      return fullWidth ? SizedBox(width: double.infinity, child: button) : button;
    }

    if (fullWidth) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final action in actions) ...[
            buildButton(action),
            if (action != actions.last) const SizedBox(height: 8),
          ],
        ],
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: actions.map(buildButton).toList(),
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
