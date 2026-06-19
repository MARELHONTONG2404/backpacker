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
    this.creatorName,
    this.executorName,
  });

  final int orderId;
  final String orderNo;
  final String title;
  final String status;
  final num rewardAmount;
  final String? description;
  final String? category;
  final String? locationText;
  final String? creatorName;
  final String? executorName;

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
      creatorName: json['creatorName'] as String?,
      executorName: json['executorName'] as String?,
    );
  }

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
      default:
        return status;
    }
  }
}
