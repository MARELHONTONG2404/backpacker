package com.iwip.system.service;

import java.util.List;
import com.iwip.system.domain.BizBackpackerNotification;

/**
 * Layanan notifikasi in-app backpacker.
 */
public interface IBackpackerNotificationService
{
    void notifyUser(Long userId, String title, String content, String notifyType, Long refId);

    List<BizBackpackerNotification> listForUser(Long userId, int limit);

    int countUnread(Long userId);

    void markAsRead(Long userId, Long notificationId);

    void markAllAsRead(Long userId);
}
