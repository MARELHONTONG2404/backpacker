package com.iwip.system.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.iwip.system.domain.BizBackpackerNotification;

/**
 * Notifikasi backpacker data layer.
 */
public interface BizBackpackerNotificationMapper
{
    int insertNotification(BizBackpackerNotification notification);

    List<BizBackpackerNotification> selectNotificationList(@Param("userId") Long userId,
            @Param("limit") int limit);

    int countUnread(@Param("userId") Long userId);

    int markAsRead(@Param("notificationId") Long notificationId, @Param("userId") Long userId);

    int markAllAsRead(@Param("userId") Long userId);
}
