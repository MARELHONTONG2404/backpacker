class ChatMessage {
  ChatMessage({
    required this.messageId,
    required this.orderId,
    required this.senderId,
    required this.content,
    this.senderName,
    this.messageType = 'TEXT',
    this.imageUrl,
    this.createTime,
  });

  final int messageId;
  final int orderId;
  final int senderId;
  final String content;
  final String? senderName;
  final String messageType;
  final String? imageUrl;
  final DateTime? createTime;

  bool get isImage => messageType == 'IMAGE' || (imageUrl?.isNotEmpty ?? false);

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    int readInt(dynamic value) {
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    DateTime? readDate(dynamic value) {
      if (value is! String || value.isEmpty) return null;
      return DateTime.tryParse(value.replaceFirst(' ', 'T'));
    }

    return ChatMessage(
      messageId: readInt(json['messageId'] ?? json['message_id']),
      orderId: readInt(json['orderId'] ?? json['order_id']),
      senderId: readInt(json['senderId'] ?? json['sender_id']),
      senderName: json['senderName'] as String? ?? json['sender_name'] as String?,
      content: json['content'] as String? ?? '',
      messageType: json['messageType'] as String? ?? json['message_type'] as String? ?? 'TEXT',
      imageUrl: json['imageUrl'] as String? ?? json['image_url'] as String?,
      createTime: readDate(json['createTime'] ?? json['create_time']),
    );
  }
}
