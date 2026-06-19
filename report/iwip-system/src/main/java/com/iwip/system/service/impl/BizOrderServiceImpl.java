package com.iwip.system.service.impl;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
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
    public List<BizOrder> selectAvailableOrderList(BizOrder order, Long currentUserId)
    {
        order.getParams().put("excludeCreatorId", currentUserId);
        return bizOrderMapper.selectAvailableOrderList(order);
    }

    @Override
    public List<BizOrder> selectMyOrderList(BizOrder order, Long userId, String scope)
    {
        String normalizedScope = StringUtils.isNotEmpty(scope) ? scope : "all";
        if (!"created".equals(normalizedScope) && !"executing".equals(normalizedScope) && !"all".equals(normalizedScope))
        {
            throw new ServiceException("Scope tidak valid. Gunakan: created, executing, atau all");
        }
        order.getParams().put("userId", userId);
        order.getParams().put("scope", normalizedScope);
        return bizOrderMapper.selectMyOrderList(order);
    }

    @Override
    public List<BizOrder> selectBizOrderList(BizOrder order)
    {
        return bizOrderMapper.selectBizOrderList(order);
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

    @Override
    @Transactional
    public BizOrder takeOrder(Long orderId, Long executorId, String username)
    {
        BizOrder existing = bizOrderMapper.selectBizOrderById(orderId);
        if (existing == null)
        {
            throw new ServiceException("Pesanan tidak ditemukan");
        }
        if (executorId.equals(existing.getCreatorId()))
        {
            throw new ServiceException("Anda tidak dapat mengambil tugas buatan sendiri");
        }
        if (!BizOrder.STATUS_PUBLISHED.equals(existing.getStatus()))
        {
            throw new ServiceException("Tugas tidak tersedia atau sudah diambil");
        }

        BizOrder update = new BizOrder();
        update.setOrderId(orderId);
        update.setExecutorId(executorId);
        update.setStatus(BizOrder.STATUS_TAKEN);
        update.setUpdateBy(username);

        if (bizOrderMapper.takeBizOrder(update) <= 0)
        {
            throw new ServiceException("Tugas sudah diambil pengguna lain");
        }

        insertOrderLog(orderId, BizOrder.STATUS_PUBLISHED, BizOrder.STATUS_TAKEN, executorId, "Tugas diambil pelaksana");
        return bizOrderMapper.selectBizOrderById(orderId);
    }

    @Override
    @Transactional
    public BizOrder startOrder(Long orderId, Long executorId, String username)
    {
        requireExecutorOrder(orderId, executorId, BizOrder.STATUS_TAKEN, "Hanya pelaksana dapat memulai tugas yang sudah diambil");

        BizOrder update = new BizOrder();
        update.setOrderId(orderId);
        update.setExecutorId(executorId);
        update.setStatus(BizOrder.STATUS_IN_PROGRESS);
        update.setUpdateBy(username);

        if (bizOrderMapper.startBizOrder(update) <= 0)
        {
            throw new ServiceException("Gagal memulai pengerjaan tugas");
        }

        insertOrderLog(orderId, BizOrder.STATUS_TAKEN, BizOrder.STATUS_IN_PROGRESS, executorId, "Pelaksana mulai mengerjakan");
        return bizOrderMapper.selectBizOrderById(orderId);
    }

    @Override
    @Transactional
    public BizOrder completeOrder(Long orderId, Long executorId, String username)
    {
        requireExecutorOrder(orderId, executorId, BizOrder.STATUS_IN_PROGRESS, "Hanya pelaksana dapat menyelesaikan tugas yang sedang dikerjakan");

        BizOrder update = new BizOrder();
        update.setOrderId(orderId);
        update.setExecutorId(executorId);
        update.setStatus(BizOrder.STATUS_COMPLETED);
        update.setUpdateBy(username);

        if (bizOrderMapper.completeBizOrder(update) <= 0)
        {
            throw new ServiceException("Gagal menyelesaikan tugas");
        }

        insertOrderLog(orderId, BizOrder.STATUS_IN_PROGRESS, BizOrder.STATUS_COMPLETED, executorId, "Tugas selesai");
        return bizOrderMapper.selectBizOrderById(orderId);
    }

    @Override
    @Transactional
    public BizOrder cancelOrder(Long orderId, Long creatorId, String username, String cancelReason)
    {
        BizOrder existing = bizOrderMapper.selectBizOrderById(orderId);
        if (existing == null)
        {
            throw new ServiceException("Pesanan tidak ditemukan");
        }
        if (!creatorId.equals(existing.getCreatorId()))
        {
            throw new ServiceException("Hanya pembuat tugas yang dapat membatalkan pesanan");
        }
        if (!BizOrder.STATUS_DRAFT.equals(existing.getStatus()) && !BizOrder.STATUS_PUBLISHED.equals(existing.getStatus()))
        {
            throw new ServiceException("Pesanan tidak dapat dibatalkan pada status ini");
        }

        BizOrder update = new BizOrder();
        update.setOrderId(orderId);
        update.setCreatorId(creatorId);
        update.setStatus(BizOrder.STATUS_CANCELLED);
        update.setCancelReason(StringUtils.isNotEmpty(cancelReason) ? cancelReason : "Dibatalkan pembuat");
        update.setUpdateBy(username);

        if (bizOrderMapper.cancelBizOrder(update) <= 0)
        {
            throw new ServiceException("Gagal membatalkan pesanan");
        }

        insertOrderLog(orderId, existing.getStatus(), BizOrder.STATUS_CANCELLED, creatorId, update.getCancelReason());
        return bizOrderMapper.selectBizOrderById(orderId);
    }

    private BizOrder requireExecutorOrder(Long orderId, Long executorId, String expectedStatus, String forbiddenMessage)
    {
        BizOrder existing = bizOrderMapper.selectBizOrderById(orderId);
        if (existing == null)
        {
            throw new ServiceException("Pesanan tidak ditemukan");
        }
        if (!executorId.equals(existing.getExecutorId()))
        {
            throw new ServiceException(forbiddenMessage);
        }
        if (!expectedStatus.equals(existing.getStatus()))
        {
            throw new ServiceException("Status pesanan tidak valid untuk aksi ini");
        }
        return existing;
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
