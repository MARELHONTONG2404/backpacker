package com.iwip.system.mapper;

import org.apache.ibatis.annotations.Param;

/**
 * Status baca chat backpacker.
 */
public interface BizBackpackerChatReadMapper
{
    int upsertReadState(@Param("orderId") Long orderId, @Param("userId") Long userId,
            @Param("lastReadMessageId") Long lastReadMessageId);

    int countUnreadForOrder(@Param("orderId") Long orderId, @Param("userId") Long userId);

    int countTotalUnread(@Param("userId") Long userId);
}
