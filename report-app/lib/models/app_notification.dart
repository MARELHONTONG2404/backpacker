class AppNotification {
  AppNotification({
    required this.notificationId,
    required this.title,
    required this.content,
    required this.notifyType,
    required this.isRead,
    this.refId,
    this.createTime,
  });

  final int notificationId;
  final String title;
  final String content;
  final String notifyType;
  final bool isRead;
  final int? refId;
  final String? createTime;

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    final readRaw = json['isRead'];
    final isRead = readRaw == true || readRaw == '1' || readRaw == 1;
    return AppNotification(
      notificationId: json['notificationId'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      notifyType: json['notifyType'] as String? ?? '',
      isRead: isRead,
      refId: json['refId'] as int?,
      createTime: json['createTime'] as String?,
    );
  }
}
