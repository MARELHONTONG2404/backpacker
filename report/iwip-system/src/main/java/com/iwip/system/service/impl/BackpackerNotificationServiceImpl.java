package com.iwip.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.iwip.common.utils.DateUtils;
import com.iwip.common.utils.StringUtils;
import com.iwip.system.domain.BizBackpackerNotification;
import com.iwip.system.mapper.BizBackpackerNotificationMapper;
import com.iwip.system.service.IBackpackerNotificationService;

/**
 * Implementasi notifikasi in-app backpacker.
 */
@Service
public class BackpackerNotificationServiceImpl implements IBackpackerNotificationService
{
    @Autowired
    private BizBackpackerNotificationMapper notificationMapper;

    @Override
    public void notifyUser(Long userId, String title, String content, String notifyType, Long refId)
    {
        if (userId == null || StringUtils.isEmpty(title))
        {
            return;
        }
        BizBackpackerNotification notification = new BizBackpackerNotification();
        notification.setUserId(userId);
        notification.setTitle(title);
        notification.setContent(StringUtils.defaultString(content));
        notification.setNotifyType(StringUtils.defaultString(notifyType));
        notification.setRefId(refId);
        notification.setCreateTime(DateUtils.getNowDate());
        notificationMapper.insertNotification(notification);
    }

    @Override
    public List<BizBackpackerNotification> listForUser(Long userId, int limit)
    {
        return notificationMapper.selectNotificationList(userId, Math.min(Math.max(limit, 1), 50));
    }

    @Override
    public int countUnread(Long userId)
    {
        return notificationMapper.countUnread(userId);
    }

    @Override
    public void markAsRead(Long userId, Long notificationId)
    {
        notificationMapper.markAsRead(notificationId, userId);
    }

    @Override
    public void markAllAsRead(Long userId)
    {
        notificationMapper.markAllAsRead(userId);
    }
}
