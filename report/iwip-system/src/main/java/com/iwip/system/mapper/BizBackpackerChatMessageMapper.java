package com.iwip.system.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.iwip.system.domain.BizBackpackerChatMessage;

/**
 * Chat backpacker data layer.
 */
public interface BizBackpackerChatMessageMapper
{
    int insertMessage(BizBackpackerChatMessage message);

    List<BizBackpackerChatMessage> selectMessages(@Param("orderId") Long orderId,
            @Param("limit") int limit, @Param("sinceId") Long sinceId);

    List<BizBackpackerChatMessage> selectAllForOrder(@Param("orderId") Long orderId,
            @Param("limit") int limit);
}
