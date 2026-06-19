package com.iwip.system.service.impl;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.iwip.common.exception.ServiceException;
import com.iwip.common.utils.DateUtils;
import com.iwip.common.utils.StringUtils;
import com.iwip.system.domain.BizOrder;
import com.iwip.system.domain.BizOrderLog;
import com.iwip.system.mapper.BizOrderMapper;
import com.iwip.system.service.IBizOrderService;

/**
 * Pesanan Backpacker service implementation.
 */
@Service
public class BizOrderServiceImpl implements IBizOrderService
{
    @Autowired
    private BizOrderMapper bizOrderMapper;

    @Override
    public BizOrder selectBizOrderById(Long orderId)
    {
        return bizOrderMapper.selectBizOrderById(orderId);
    }

    @Override
    @Transactional
    public BizOrder createOrder(BizOrder order, Long creatorId, String username)
    {
        order.setOrderNo(generateOrderNo());
        order.setCreatorId(creatorId);
        order.setStatus(BizOrder.STATUS_DRAFT);
        order.setVersion(0);
        order.setCategory(StringUtils.isNotEmpty(order.getCategory()) ? order.getCategory() : "general");
        order.setCreateBy(username);
        order.setCreateTime(DateUtils.getNowDate());

        if (bizOrderMapper.insertBizOrder(order) <= 0)
        {
            throw new ServiceException("Gagal membuat pesanan");
        }

        insertOrderLog(order.getOrderId(), null, BizOrder.STATUS_DRAFT, creatorId, "Pesanan dibuat");
        return bizOrderMapper.selectBizOrderById(order.getOrderId());
    }

    @Override
    @Transactional
    public BizOrder publishOrder(Long orderId, Long creatorId, String username)
    {
        BizOrder existing = bizOrderMapper.selectBizOrderById(orderId);
        if (existing == null)
        {
            throw new ServiceException("Pesanan tidak ditemukan");
        }
        if (!creatorId.equals(existing.getCreatorId()))
        {
            throw new ServiceException("Hanya pembuat tugas yang dapat mempublikasikan pesanan");
        }
        if (!BizOrder.STATUS_DRAFT.equals(existing.getStatus()))
        {
            throw new ServiceException("Hanya pesanan berstatus DRAFT yang dapat dipublikasikan");
        }

        BizOrder update = new BizOrder();
        update.setOrderId(orderId);
        update.setCreatorId(creatorId);
        update.setStatus(BizOrder.STATUS_PUBLISHED);
        update.setUpdateBy(username);

        if (bizOrderMapper.publishBizOrder(update) <= 0)
        {
            throw new ServiceException("Gagal mempublikasikan pesanan");
        }

        insertOrderLog(orderId, BizOrder.STATUS_DRAFT, BizOrder.STATUS_PUBLISHED, creatorId, "Pesanan dipublikasikan");
        return bizOrderMapper.selectBizOrderById(orderId);
    }

    private void insertOrderLog(Long orderId, String fromStatus, String toStatus, Long operatorId, String remark)
    {
        BizOrderLog log = new BizOrderLog();
        log.setOrderId(orderId);
        log.setFromStatus(fromStatus);
        log.setToStatus(toStatus);
        log.setOperatorId(operatorId);
        log.setOperatorType("user");
        log.setRemark(remark);
        bizOrderMapper.insertBizOrderLog(log);
    }

    private String generateOrderNo()
    {
        String datePart = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        return "ORD-" + datePart + "-" + String.format("%04d", System.currentTimeMillis() % 10000);
    }
}
