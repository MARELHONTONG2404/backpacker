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

    return OrderItem(
      orderId: readInt(json['orderId']),
      orderNo: json['orderNo'] as String? ?? '',
      title: json['title'] as String? ?? '',
      status: json['status'] as String? ?? '',
      rewardAmount: json['rewardAmount'] as num? ?? 0,
      description: json['description'] as String?,
      category: json['category'] as String?,
      locationText: json['locationText'] as String?,
      creatorId: json['creatorId'] == null ? null : readInt(json['creatorId']),
      executorId: json['executorId'] == null ? null : readInt(json['executorId']),
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

  String get statusLabel {
    switch (status) {
      case 'DRAFT':
        return 'Draft';
      case 'PUBLISHED':
        return 'Dipublikasikan';
      case 'TAKEN':
        return 'Diambil';
      case 'IN_PROGRESS':
        return 'Dikerjakan';
      case 'COMPLETED':
        return 'Selesai';
      case 'CANCELLED':
        return 'Dibatalkan';
      case 'EXPIRED':
        return 'Kedaluwarsa';
      default:
        return status;
    }
  }

  String get categoryLabel {
    switch (category) {
      case 'delivery':
        return 'Antar Barang';
      case 'helper':
        return 'Bantuan';
      case 'tech':
        return 'Teknisi';
      case 'errands':
        return 'Belanja / Errands';
      default:
        return 'Umum';
    }
  }

  /// Aksi lifecycle sesuai status dan peran user (pembuat vs pelaksana).
  List<OrderAction> availableActions(int? userId, {bool marketplace = false}) {
    if (userId == null) return [];

    switch (status) {
      case 'DRAFT':
        if (isCreator(userId)) {
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
          return [OrderAction.start, OrderAction.abandon];
        }
        return [];
      case 'IN_PROGRESS':
        if (isExecutor(userId)) {
          return [OrderAction.complete, OrderAction.abandon];
        }
        return [];
      default:
        return [];
    }
  }

  String roleLabel(int? userId) {
    if (userId == null) return '';
    if (isCreator(userId) && isExecutor(userId)) return 'Pembuat & Pelaksana';
    if (isCreator(userId)) return 'Pembuat tugas';
    if (isExecutor(userId)) return 'Pelaksana';
    return '';
  }
}

enum OrderAction {
  publish('publish', 'Publish'),
  cancel('cancel', 'Batalkan'),
  take('take', 'Ambil Tugas'),
  start('start', 'Mulai Kerjakan'),
  complete('complete', 'Selesai'),
  abandon('abandon', 'Lepas Tugas');

  const OrderAction(this.apiKey, this.label);

  final String apiKey;
  final String label;

  String message(BackpackerProfile? profile) {
    switch (this) {
      case OrderAction.publish:
        final fee = profile?.publishFee ?? 5;
        return 'Publikasikan tugas ke marketplace? Biaya publikasi: $fee koin tembaga.';
      case OrderAction.cancel:
        return 'Batalkan pesanan ini?';
      case OrderAction.take:
        return 'Ambil tugas ini dan kerjakan sebagai pelaksana?';
      case OrderAction.start:
        return 'Mulai mengerjakan tugas ini?';
      case OrderAction.complete:
        final coins = profile?.taskRewardCoins ?? 3;
        final rep = profile?.reputationTaskComplete ?? 5;
        return 'Tandai tugas selesai? Anda mendapat +$coins koin dan +$rep reputasi.';
      case OrderAction.abandon:
        return 'Lepas tugas ini? Reputasi Anda akan menurun.';
    }
  }

  bool get needsCancelReason => this == OrderAction.cancel || this == OrderAction.abandon;

  bool get isPrimary =>
      this == OrderAction.take || this == OrderAction.start || this == OrderAction.complete;
}
