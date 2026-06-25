package com.iwip.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.iwip.common.exception.ServiceException;
import com.iwip.common.utils.DateUtils;
import com.iwip.common.utils.StringUtils;
import com.iwip.system.domain.BizBackpackerChatMessage;
import com.iwip.system.domain.BizOrder;
import com.iwip.system.mapper.BizBackpackerChatMessageMapper;
import com.iwip.system.mapper.BizBackpackerChatReadMapper;
import com.iwip.system.mapper.BizOrderMapper;
import com.iwip.system.service.IBackpackerChatService;
import com.iwip.system.service.IBackpackerNotificationService;

/**
 * Implementasi chat per pesanan backpacker.
 */
@Service
public class BackpackerChatServiceImpl implements IBackpackerChatService
{
    public static final String TYPE_TEXT = "TEXT";
    public static final String TYPE_IMAGE = "IMAGE";

    private static final int MAX_CONTENT_LENGTH = 2000;

    @Autowired
    private BizBackpackerChatMessageMapper chatMessageMapper;

    @Autowired
    private BizBackpackerChatReadMapper chatReadMapper;

    @Autowired
    private BizOrderMapper bizOrderMapper;

    @Autowired
    private IBackpackerNotificationService notificationService;

    @Override
    public List<BizBackpackerChatMessage> listMessages(Long orderId, Long userId, int limit, Long sinceId)
    {
        assertChatAccess(orderId, userId);
        int safeLimit = Math.min(Math.max(limit, 1), 100);
        return chatMessageMapper.selectMessages(orderId, safeLimit, sinceId);
    }

    @Override
    public List<BizBackpackerChatMessage> listMessagesForAdmin(Long orderId, int limit)
    {
        if (bizOrderMapper.selectBizOrderById(orderId) == null)
        {
            throw new ServiceException("Pesanan tidak ditemukan");
        }
        int safeLimit = Math.min(Math.max(limit, 1), 500);
        return chatMessageMapper.selectAllForOrder(orderId, safeLimit);
    }

    @Override
    public BizBackpackerChatMessage sendMessage(Long orderId, Long userId, String senderName, String content,
            String imageUrl)
    {
        BizOrder order = assertChatAccess(orderId, userId);
        String trimmed = StringUtils.trim(content);
        String image = StringUtils.trim(imageUrl);
        boolean hasText = StringUtils.isNotEmpty(trimmed);
        boolean hasImage = StringUtils.isNotEmpty(image);
        if (!hasText && !hasImage)
        {
            throw new ServiceException("Pesan tidak boleh kosong");
        }
        if (hasText && trimmed.length() > MAX_CONTENT_LENGTH)
        {
            throw new ServiceException("Pesan terlalu panjang (maks. " + MAX_CONTENT_LENGTH + " karakter)");
        }

        BizBackpackerChatMessage message = new BizBackpackerChatMessage();
        message.setOrderId(orderId);
        message.setSenderId(userId);
        message.setSenderName(StringUtils.defaultString(senderName, "Backpacker"));
        message.setContent(hasText ? trimmed : "");
        message.setMessageType(hasImage ? TYPE_IMAGE : TYPE_TEXT);
        message.setImageUrl(hasImage ? image : null);
        message.setCreateTime(DateUtils.getNowDate());
        chatMessageMapper.insertMessage(message);

        Long recipientId = userId.equals(order.getCreatorId()) ? order.getExecutorId() : order.getCreatorId();
        if (recipientId != null)
        {
            String preview = hasImage ? "[Gambar]" : (trimmed.length() > 80 ? trimmed.substring(0, 80) + "..." : trimmed);
            notificationService.notifyUser(
                    recipientId,
                    "Pesan chat baru",
                    message.getSenderName() + ": " + preview,
                    "CHAT_MESSAGE",
                    orderId);
        }
        return message;
    }

    @Override
    public void markAsRead(Long orderId, Long userId, Long lastMessageId)
    {
        assertChatAccess(orderId, userId);
        if (lastMessageId == null || lastMessageId <= 0)
        {
            return;
        }
        chatReadMapper.upsertReadState(orderId, userId, lastMessageId);
    }

    @Override
    public int countUnreadForOrder(Long orderId, Long userId)
    {
        assertChatAccess(orderId, userId);
        return chatReadMapper.countUnreadForOrder(orderId, userId);
    }

    @Override
    public int countTotalUnread(Long userId)
    {
        return chatReadMapper.countTotalUnread(userId);
    }

    private BizOrder assertChatAccess(Long orderId, Long userId)
    {
        BizOrder order = bizOrderMapper.selectBizOrderById(orderId);
        if (order == null)
        {
            throw new ServiceException("Pesanan tidak ditemukan");
        }
        if (!userId.equals(order.getCreatorId())
                && (order.getExecutorId() == null || !userId.equals(order.getExecutorId())))
        {
            throw new ServiceException("Anda tidak memiliki akses ke chat pesanan ini");
        }
        String status = order.getStatus();
        if (!BizOrder.STATUS_TAKEN.equals(status)
                && !BizOrder.STATUS_IN_PROGRESS.equals(status)
                && !BizOrder.STATUS_COMPLETED.equals(status))
        {
            throw new ServiceException("Chat hanya tersedia setelah tugas diambil pelaksana");
        }
        return order;
    }
}
