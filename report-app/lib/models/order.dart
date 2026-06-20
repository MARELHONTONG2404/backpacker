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
    return OrderItem(
      orderId: json['orderId'] as int,
      orderNo: json['orderNo'] as String? ?? '',
      title: json['title'] as String? ?? '',
      status: json['status'] as String? ?? '',
      rewardAmount: json['rewardAmount'] as num? ?? 0,
      description: json['description'] as String?,
      category: json['category'] as String?,
      locationText: json['locationText'] as String?,
      creatorId: json['creatorId'] as int?,
      executorId: json['executorId'] as int?,
      creatorName: json['creatorName'] as String?,
      executorName: json['executorName'] as String?,
      cancelReason: json['cancelReason'] as String?,
      ratingScore: json['ratingScore'] as int?,
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
  publish('publish', 'Publish', 'Publikasikan tugas ke marketplace? Biaya: 5 koin tembaga.'),
  cancel('cancel', 'Batalkan', 'Batalkan pesanan ini?'),
  take('take', 'Ambil Tugas', 'Ambil tugas ini?'),
  start('start', 'Mulai Kerjakan', 'Mulai mengerjakan tugas?'),
  complete('complete', 'Selesai', 'Tandai tugas sebagai selesai? Anda akan mendapat +3 koin dan +5 reputasi.'),
  abandon('abandon', 'Lepas Tugas', 'Lepas tugas ini? Reputasi Anda akan berkurang.');

  const OrderAction(this.apiKey, this.label, this.confirmMessage);

  final String apiKey;
  final String label;
  final String confirmMessage;

  bool get needsCancelReason => this == OrderAction.cancel || this == OrderAction.abandon;

  bool get isPrimary =>
      this == OrderAction.take || this == OrderAction.start || this == OrderAction.complete;
}
