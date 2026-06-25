import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../l10n/l10n_extension.dart';
import '../models/chat_message.dart';
import '../models/order.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class OrderChatScreen extends StatefulWidget {
  const OrderChatScreen({
    super.key,
    required this.api,
    required this.order,
    required this.userId,
  });

  final ApiService api;
  final OrderItem order;
  final int userId;

  @override
  State<OrderChatScreen> createState() => _OrderChatScreenState();
}

class _OrderChatScreenState extends State<OrderChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final _picker = ImagePicker();
  final _messages = <ChatMessage>[];
  Timer? _pollTimer;
  bool _loading = true;
  bool _sending = false;
  int? _lastMessageId;

  String get _counterpartName {
    final order = widget.order;
    if (order.isCreator(widget.userId)) {
      return order.executorName ?? context.l10n.executor;
    }
    return order.creatorName ?? context.l10n.creator;
  }

  @override
  void initState() {
    super.initState();
    _loadMessages(initial: true);
    _pollTimer = Timer.periodic(const Duration(seconds: 4), (_) => _loadMessages());
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _markRead() async {
    if (_lastMessageId == null) return;
    try {
      await widget.api.markOrderChatRead(widget.order.orderId, _lastMessageId!);
    } catch (_) {}
  }

  Future<void> _loadMessages({bool initial = false}) async {
    if (!mounted) return;
    try {
      final incoming = await widget.api.fetchOrderChatMessages(
        widget.order.orderId,
        sinceId: initial ? null : _lastMessageId,
      );
      if (!mounted) return;
      if (incoming.isEmpty) {
        if (initial) setState(() => _loading = false);
        return;
      }

      final existingIds = _messages.map((m) => m.messageId).toSet();
      final fresh = incoming.where((m) => !existingIds.contains(m.messageId)).toList();
      if (fresh.isEmpty) {
        if (initial) setState(() => _loading = false);
        return;
      }

      setState(() {
        _messages.addAll(fresh);
        _lastMessageId = _messages.last.messageId;
        _loading = false;
      });
      await _markRead();
      _scrollToBottom();
    } on ApiException catch (error) {
      if (!mounted) return;
      if (initial) {
        setState(() => _loading = false);
        showLocalizedAppMessage(context, error.message);
      }
    }
  }

  Future<void> _sendMessage({String? imageUrl}) async {
    final text = _messageController.text.trim();
    if ((text.isEmpty && imageUrl == null) || _sending) return;

    setState(() => _sending = true);
    try {
      final sent = await widget.api.sendOrderChatMessage(
        widget.order.orderId,
        content: text.isEmpty ? null : text,
        imageUrl: imageUrl,
      );
      _messageController.clear();
      if (!mounted) return;
      setState(() {
        _messages.add(sent);
        _lastMessageId = sent.messageId;
      });
      await _markRead();
      _scrollToBottom();
    } on ApiException catch (error) {
      if (mounted) showLocalizedAppMessage(context, error.message);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _pickImage() async {
    if (_sending) return;
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
        imageQuality: 85,
      );
      if (picked == null) return;
      setState(() => _sending = true);
      final bytes = await picked.readAsBytes();
      final filename = picked.name.isNotEmpty ? picked.name : 'chat.jpg';
      final url = await widget.api.uploadChatImage(bytes, filename);
      final caption = _messageController.text.trim();
      final sent = await widget.api.sendOrderChatMessage(
        widget.order.orderId,
        content: caption.isEmpty ? null : caption,
        imageUrl: url,
      );
      _messageController.clear();
      if (!mounted) return;
      setState(() {
        _messages.add(sent);
        _lastMessageId = sent.messageId;
      });
      await _markRead();
      _scrollToBottom();
    } on ApiException catch (error) {
      if (mounted) showLocalizedAppMessage(context, error.message);
    } catch (_) {
      if (mounted) showLocalizedAppMessage(context, context.l10n.chatImageFailed);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.orderChatTitle),
            Text(
              _counterpartName,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _loading
                ? LoadingView(message: l10n.loadingChat)
                : _messages.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.chat_bubble_outline, size: 56, color: AppColors.textSecondary),
                              const SizedBox(height: 16),
                              Text(
                                l10n.chatEmptyTitle,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                l10n.chatEmptySubtitle,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: AppColors.textSecondary, height: 1.4),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final message = _messages[index];
                          final isMine = message.senderId == widget.userId;
                          return _ChatBubble(message: message, isMine: isMine);
                        },
                      ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: _sending ? null : _pickImage,
                    tooltip: l10n.chatAttachImage,
                    icon: const Icon(Icons.image_outlined),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: l10n.chatInputHint,
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _sending ? null : () => _sendMessage(),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(48, 48),
                      padding: EdgeInsets.zero,
                      shape: const CircleBorder(),
                    ),
                    child: _sending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.send_rounded),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.message, required this.isMine});

  final ChatMessage message;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    final time = message.createTime;
    final timeLabel = time == null
        ? ''
        : '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.78),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMine
              ? AppColors.primary.withValues(alpha: 0.92)
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMine ? 16 : 4),
            bottomRight: Radius.circular(isMine ? 4 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMine && (message.senderName?.isNotEmpty ?? false))
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  message.senderName!,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isMine ? Colors.white70 : AppColors.primary,
                  ),
                ),
              ),
            if (message.isImage && message.imageUrl?.isNotEmpty == true) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  message.imageUrl!,
                  width: 220,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return SizedBox(
                      width: 220,
                      height: 140,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: progress.expectedTotalBytes == null
                              ? null
                              : progress.cumulativeBytesLoaded / progress.expectedTotalBytes!,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 220,
                    height: 120,
                    alignment: Alignment.center,
                    color: Colors.black12,
                    child: Icon(Icons.broken_image_outlined, color: isMine ? Colors.white70 : AppColors.textSecondary),
                  ),
                ),
              ),
              if (message.content.isNotEmpty) const SizedBox(height: 8),
            ],
            if (message.content.isNotEmpty)
              Text(
                message.content,
                style: TextStyle(
                  color: isMine ? Colors.white : Theme.of(context).colorScheme.onSurface,
                  height: 1.35,
                ),
              ),
            if (timeLabel.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                timeLabel,
                style: TextStyle(
                  fontSize: 10,
                  color: isMine ? Colors.white70 : AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
