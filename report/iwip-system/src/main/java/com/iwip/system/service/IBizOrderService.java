package com.iwip.system.service;

import java.util.List;
import com.iwip.system.domain.BizOrder;

/**
 * Pesanan Backpacker service layer.
 */
public interface IBizOrderService
{
    BizOrder selectBizOrderById(Long orderId);

    List<BizOrder> selectAvailableOrderList(BizOrder order, Long currentUserId);

    List<BizOrder> selectMyOrderList(BizOrder order, Long userId, String scope);

    List<BizOrder> selectBizOrderList(BizOrder order);

    BizOrder createOrder(BizOrder order, Long creatorId, String username);

    BizOrder publishOrder(Long orderId, Long creatorId, String username);

    BizOrder takeOrder(Long orderId, Long executorId, String username);

    BizOrder startOrder(Long orderId, Long executorId, String username);

    BizOrder completeOrder(Long orderId, Long executorId, String username);

    BizOrder cancelOrder(Long orderId, Long creatorId, String username, String cancelReason);
}
