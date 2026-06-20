package com.iwip.system.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.iwip.system.domain.BizOrder;
import com.iwip.system.domain.BizOrderLog;

/**
 * Pesanan Backpacker data layer.
 */
public interface BizOrderMapper
{
    BizOrder selectBizOrderById(Long orderId);

    List<BizOrder> selectAvailableOrderList(BizOrder order);

    List<BizOrder> selectMyOrderList(BizOrder order);

    List<BizOrder> selectBizOrderList(BizOrder order);

    int countAllOrders();

    int countOrdersByStatus(String status);

    int countOrdersThisMonth();

    List<java.util.Map<String, Object>> countOrdersGroupByStatus();

    List<java.util.Map<String, Object>> countOrdersGroupByMonth(int months);

    int insertBizOrder(BizOrder order);

    int publishBizOrder(BizOrder order);

    int takeBizOrder(BizOrder order);

    int startBizOrder(BizOrder order);

    int completeBizOrder(BizOrder order);

    int cancelBizOrder(BizOrder order);

    int abandonBizOrder(BizOrder order);

    int expireStalePublishedOrders(@Param("days") int days);

    int insertBizOrderLog(BizOrderLog log);
}
