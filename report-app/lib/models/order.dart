import '../l10n/app_localizations.dart';
import 'backpacker_profile.dart';

class OrderItem {
  OrderItem({
    required this.orderId,
    required this.orderNo,
    required this.title,
    required this.status,
    required this.rewardAmount,
    this.description,
    this.category,
    this.locationText,
    this.creatorId,
    this.executorId,
    this.creatorName,
    this.executorName,
    this.cancelReason,
    this.ratingScore,
    this.ratingComment,
  });

  final int orderId;
  final String orderNo;
  final String title;
  final String status;
  final num rewardAmount;
  final String? description;
  final String? category;
  final String? locationText;
  final int? creatorId;
  final int? executorId;
  final String? creatorName;
  final String? executorName;
  final String? cancelReason;
  final int? ratingScore;
  final String? ratingComment;

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    int readInt(dynamic value) {
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    int? readOptionalInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value);
      return null;
    }

    return OrderItem(
      orderId: readInt(json['orderId'] ?? json['order_id']),
      orderNo: json['orderNo'] as String? ?? json['order_no'] as String? ?? '',
      title: json['title'] as String? ?? '',
      status: json['status'] as String? ?? '',
      rewardAmount: json['rewardAmount'] as num? ?? json['reward_amount'] as num? ?? 0,
      description: json['description'] as String?,
      category: json['category'] as String?,
      locationText: json['locationText'] as String? ?? json['location_text'] as String?,
      creatorId: readOptionalInt(json['creatorId'] ?? json['creator_id']),
      executorId: readOptionalInt(json['executorId'] ?? json['executor_id']),
      creatorName: json['creatorName'] as String?,
      executorName: json['executorName'] as String?,
      cancelReason: json['cancelReason'] as String?,
      ratingScore: json['ratingScore'] == null ? null : readInt(json['ratingScore']),
      ratingComment: json['ratingComment'] as String?,
    );
  }

  bool get isRated => ratingScore != null;

  bool canRate(int? userId) =>
      userId != null && isCreator(userId) && status == 'COMPLETED' && !isRated;

  bool isCreator(int? userId) => userId != null && creatorId == userId;

  bool isExecutor(int? userId) => userId != null && executorId == userId;

  bool canChat(int? userId) =>
      isParticipant(userId) &&
      (status == 'TAKEN' || status == 'IN_PROGRESS' || status == 'SUBMITTED' || status == 'COMPLETED');

  bool isParticipant(int? userId) =>
      userId != null && (isCreator(userId) || isExecutor(userId));

  String? chatUnavailableReason(AppLocalizations l10n) {
    switch (status) {
      case 'DRAFT':
        return l10n.chatUnavailableDraft;
      case 'PUBLISHED':
        return l10n.chatUnavailablePublished;
      case 'CANCELLED':
        return l10n.chatUnavailableCancelled;
      case 'EXPIRED':
        return l10n.chatUnavailableExpired;
      default:
        return null;
    }
  }

  String statusLabel(AppLocalizations l10n) {
    switch (status) {
      case 'DRAFT':
        return l10n.statusDraft;
      case 'PUBLISHED':
        return l10n.statusPublished;
      case 'TAKEN':
        return l10n.statusTaken;
      case 'IN_PROGRESS':
        return l10n.statusInProgress;
      case 'SUBMITTED':
        return l10n.statusSubmitted;
      case 'COMPLETED':
        return l10n.statusCompleted;
      case 'CANCELLED':
        return l10n.statusCancelled;
      case 'EXPIRED':
        return l10n.statusExpired;
      default:
        return status;
    }
  }

  String categoryLabel(AppLocalizations l10n) {
    switch (category) {
      case 'delivery':
        return l10n.categoryDelivery;
      case 'helper':
        return l10n.categoryHelper;
      case 'tech':
        return l10n.categoryTech;
      case 'errands':
        return l10n.categoryErrands;
      default:
        return l10n.categoryGeneral;
    }
  }

  List<OrderAction> availableActions(
    int? userId, {
    bool marketplace = false,
    bool myOrders = false,
  }) {
    if (userId == null) return [];

    switch (status) {
      case 'DRAFT':
        if (isCreator(userId) || myOrders) {
          return [OrderAction.publish, OrderAction.cancel];
        }
        return [];
      case 'PUBLISHED':
        if (marketplace && !isCreator(userId)) {
          return [OrderAction.take];
        }
        if (isCreator(userId)) {
          return [OrderAction.cancel];
        }
        return [];
      case 'TAKEN':
        if (isExecutor(userId)) {
          return [OrderAction.submit, OrderAction.abandon];
        }
        return [];
      case 'IN_PROGRESS':
        if (isExecutor(userId)) {
          return [OrderAction.submit, OrderAction.abandon];
        }
        return [];
      case 'SUBMITTED':
        if (isCreator(userId)) {
          return [OrderAction.confirm];
        }
        return [];
      default:
        return [];
    }
  }

  String roleLabel(AppLocalizations l10n, int? userId) {
    if (userId == null) return '';
    if (isCreator(userId) && isExecutor(userId)) return l10n.roleCreatorAndExecutor;
    if (isCreator(userId)) return l10n.roleCreator;
    if (isExecutor(userId)) return l10n.roleExecutor;
    return '';
  }
}

enum OrderAction {
  publish('publish'),
  cancel('cancel'),
  take('take'),
  start('start'),
  submit('submit'),
  confirm('confirm'),
  abandon('abandon');

  const OrderAction(this.apiKey);

  final String apiKey;

  String label(AppLocalizations l10n) {
    switch (this) {
      case OrderAction.publish:
        return l10n.actionPublish;
      case OrderAction.cancel:
        return l10n.actionCancel;
      case OrderAction.take:
        return l10n.actionTake;
      case OrderAction.start:
        return l10n.actionStart;
      case OrderAction.submit:
        return l10n.actionSubmit;
      case OrderAction.confirm:
        return l10n.actionConfirm;
      case OrderAction.abandon:
        return l10n.actionAbandon;
    }
  }

  String message(AppLocalizations l10n, BackpackerProfile? profile) {
    switch (this) {
      case OrderAction.publish:
        return l10n.actionPublishMessage(profile?.publishFee ?? 5);
      case OrderAction.cancel:
        return l10n.actionCancelMessage;
      case OrderAction.take:
        return l10n.actionTakeMessage;
      case OrderAction.start:
        return l10n.actionStartMessage;
      case OrderAction.submit:
        return l10n.actionSubmitMessage;
      case OrderAction.confirm:
        return l10n.actionConfirmMessage(
          profile?.taskRewardCoins ?? 3,
          profile?.reputationTaskComplete ?? 5,
        );
      case OrderAction.abandon:
        return l10n.actionAbandonMessage;
    }
  }

  bool get needsCancelReason => this == OrderAction.cancel || this == OrderAction.abandon;

  bool get isPrimary =>
      this == OrderAction.publish ||
      this == OrderAction.take ||
      this == OrderAction.start ||
      this == OrderAction.submit ||
      this == OrderAction.confirm;
}
