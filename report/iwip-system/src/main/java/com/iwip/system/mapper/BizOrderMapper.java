package com.iwip.system.mapper;

import com.iwip.system.domain.BizOrder;
import com.iwip.system.domain.BizOrderLog;

/**
 * Pesanan Backpacker data layer.
 */
public interface BizOrderMapper
{
    BizOrder selectBizOrderById(Long orderId);

    int insertBizOrder(BizOrder order);

    int publishBizOrder(BizOrder order);

    int insertBizOrderLog(BizOrderLog log);
}
