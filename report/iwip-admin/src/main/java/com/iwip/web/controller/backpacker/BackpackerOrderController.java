package com.iwip.web.controller.backpacker;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.iwip.common.core.controller.BaseController;
import com.iwip.common.core.domain.AjaxResult;
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

    @GetMapping("/{orderId}")
    public AjaxResult detail(@PathVariable Long orderId)
    {
        BizOrder order = bizOrderService.selectBizOrderById(orderId);
        if (order == null)
        {
            return error("Pesanan tidak ditemukan");
        }
        if (!getUserId().equals(order.getCreatorId())
                && (order.getExecutorId() == null || !getUserId().equals(order.getExecutorId())))
        {
            return error("Anda tidak memiliki akses ke pesanan ini");
        }
        return success(order);
    }
}
