package com.iwip.web.controller.backpacker;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.iwip.common.core.controller.BaseController;
import com.iwip.common.core.domain.AjaxResult;
import com.iwip.common.core.page.TableDataInfo;
import com.iwip.system.domain.BizOrder;
import com.iwip.system.service.IBizOrderService;

/**
 * Monitoring pesanan Backpacker untuk panel admin.
 */
@RestController
@RequestMapping("/backpacker/order")
public class BizOrderAdminController extends BaseController
{
    @Autowired
    private IBizOrderService bizOrderService;

    @PreAuthorize("@ss.hasPermi('backpacker:order:list')")
    @GetMapping("/list")
    public TableDataInfo list(BizOrder order)
    {
        startPage();
        List<BizOrder> list = bizOrderService.selectBizOrderList(order);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('backpacker:order:list')")
    @GetMapping("/stats")
    public AjaxResult stats()
    {
        return success(bizOrderService.selectOrderStats());
    }

    @PreAuthorize("@ss.hasPermi('backpacker:order:query')")
    @GetMapping("/{orderId}")
    public AjaxResult getInfo(@PathVariable Long orderId)
    {
        return success(bizOrderService.selectBizOrderById(orderId));
    }
}
