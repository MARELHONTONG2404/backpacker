package com.iwip.web.controller.backpacker;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.iwip.common.core.controller.BaseController;
import com.iwip.common.core.domain.AjaxResult;
import com.iwip.common.core.domain.model.BackpackerOrderRateBody;
import com.iwip.common.core.page.TableDataInfo;
import com.iwip.common.exception.ServiceException;
import com.iwip.system.domain.BizOrder;
import com.iwip.system.service.IBizOrderService;

/**
 * API pesanan Backpacker untuk aplikasi mobile.
 */
@RestController
@RequestMapping("/backpacker/orders")
public class BackpackerOrderController extends BaseController
{
    @Autowired
    private IBizOrderService bizOrderService;

    @GetMapping("/available")
    public TableDataInfo available(BizOrder order)
    {
        startPage();
        List<BizOrder> list = bizOrderService.selectAvailableOrderList(order, getUserId());
        return getDataTable(list);
    }

    @GetMapping("/mine")
    public TableDataInfo mine(BizOrder order, @RequestParam(defaultValue = "all") String scope)
    {
        startPage();
        List<BizOrder> list = bizOrderService.selectMyOrderList(order, getUserId(), scope);
        return getDataTable(list);
    }

    @PostMapping
    public AjaxResult create(@Validated @RequestBody BizOrder order)
    {
        BizOrder created = bizOrderService.createOrder(order, getUserId(), getUsername());
        return AjaxResult.success("Pesanan berhasil dibuat", created);
    }

    @PostMapping("/{orderId}/publish")
    public AjaxResult publish(@PathVariable Long orderId)
    {
        try
        {
            BizOrder published = bizOrderService.publishOrder(orderId, getUserId(), getUsername());
            return AjaxResult.success("Pesanan berhasil dipublikasikan", published);
        }
        catch (ServiceException ex)
        {
            return error(ex.getMessage());
        }
    }

    @PostMapping("/{orderId}/take")
    public AjaxResult take(@PathVariable Long orderId)
    {
        try
        {
            BizOrder taken = bizOrderService.takeOrder(orderId, getUserId(), getUsername());
            return AjaxResult.success("Tugas berhasil diambil", taken);
        }
        catch (ServiceException ex)
        {
            return error(ex.getMessage());
        }
    }

    @PostMapping("/{orderId}/start")
    public AjaxResult start(@PathVariable Long orderId)
    {
        try
        {
            BizOrder started = bizOrderService.startOrder(orderId, getUserId(), getUsername());
            return AjaxResult.success("Tugas mulai dikerjakan", started);
        }
        catch (ServiceException ex)
        {
            return error(ex.getMessage());
        }
    }

    @PostMapping("/{orderId}/submit")
    public AjaxResult submit(@PathVariable Long orderId)
    {
        try
        {
            BizOrder submitted = bizOrderService.submitOrder(orderId, getUserId(), getUsername());
            return AjaxResult.success("Pengajuan selesai terkirim", submitted);
        }
        catch (ServiceException ex)
        {
            return error(ex.getMessage());
        }
    }

    @PostMapping("/{orderId}/confirm")
    public AjaxResult confirm(@PathVariable Long orderId)
    {
        try
        {
            BizOrder confirmed = bizOrderService.confirmOrder(orderId, getUserId(), getUsername());
            return AjaxResult.success("Tugas dikonfirmasi selesai", confirmed);
        }
        catch (ServiceException ex)
        {
            return error(ex.getMessage());
        }
    }

    @PostMapping("/{orderId}/cancel")
    public AjaxResult cancel(@PathVariable Long orderId, @RequestBody(required = false) BizOrder body)
    {
        try
        {
            String reason = body != null ? body.getCancelReason() : null;
            BizOrder cancelled = bizOrderService.cancelOrder(orderId, getUserId(), getUsername(), reason);
            return AjaxResult.success("Pesanan berhasil dibatalkan", cancelled);
        }
        catch (ServiceException ex)
        {
            return error(ex.getMessage());
        }
    }

    @PostMapping("/{orderId}/abandon")
    public AjaxResult abandon(@PathVariable Long orderId, @RequestBody(required = false) BizOrder body)
    {
        try
        {
            String reason = body != null ? body.getCancelReason() : null;
            BizOrder abandoned = bizOrderService.abandonOrder(orderId, getUserId(), getUsername(), reason);
            return AjaxResult.success("Tugas berhasil dilepas", abandoned);
        }
        catch (ServiceException ex)
        {
            return error(ex.getMessage());
        }
    }

    @PostMapping("/{orderId}/rate")
    public AjaxResult rate(@PathVariable Long orderId, @RequestBody BackpackerOrderRateBody body)
    {
        try
        {
            BizOrder rated = bizOrderService.rateOrder(orderId, getUserId(), body.getScore(), body.getComment());
            return AjaxResult.success("Penilaian berhasil disimpan", rated);
        }
        catch (ServiceException ex)
        {
            return error(ex.getMessage());
        }
    }

    @GetMapping("/{orderId}")
    public AjaxResult detail(@PathVariable Long orderId)
    {
        BizOrder order = bizOrderService.selectBizOrderById(orderId);
        if (order == null)
        {
            return error("Pesanan tidak ditemukan");
        }
        if (BizOrder.STATUS_PUBLISHED.equals(order.getStatus()))
        {
            return success(order);
        }
        if (!getUserId().equals(order.getCreatorId())
                && (order.getExecutorId() == null || !getUserId().equals(order.getExecutorId())))
        {
            return error("Anda tidak memiliki akses ke pesanan ini");
        }
        return success(order);
    }
}
