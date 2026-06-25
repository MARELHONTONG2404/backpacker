package com.iwip.system.service;

import java.util.List;
import com.iwip.system.domain.BizBackpackerChatMessage;

/**
 * Layanan chat per pesanan backpacker.
 */
public interface IBackpackerChatService
{
    List<BizBackpackerChatMessage> listMessages(Long orderId, Long userId, int limit, Long sinceId);

    List<BizBackpackerChatMessage> listMessagesForAdmin(Long orderId, int limit);

    BizBackpackerChatMessage sendMessage(Long orderId, Long userId, String senderName, String content, String imageUrl);

    void markAsRead(Long orderId, Long userId, Long lastMessageId);

    int countUnreadForOrder(Long orderId, Long userId);

    int countTotalUnread(Long userId);
}
