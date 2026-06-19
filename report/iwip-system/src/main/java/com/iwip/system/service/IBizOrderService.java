package com.iwip.system.service;

import com.iwip.system.domain.BizOrder;

/**
 * Pesanan Backpacker service layer.
 */
public interface IBizOrderService
{
    BizOrder selectBizOrderById(Long orderId);

    BizOrder createOrder(BizOrder order, Long creatorId, String username);

    BizOrder publishOrder(Long orderId, Long creatorId, String username);
}
