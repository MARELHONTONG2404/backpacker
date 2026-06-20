package com.iwip.web.controller.backpacker;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.iwip.common.core.controller.BaseController;
import com.iwip.common.core.page.TableDataInfo;
import com.iwip.system.domain.BizCoinTransaction;
import com.iwip.system.service.IBackpackerAdminService;

/**
 * Riwayat transaksi koin untuk panel admin.
 */
@RestController
@RequestMapping("/backpacker/coin")
public class BackpackerCoinAdminController extends BaseController
{
    @Autowired
    private IBackpackerAdminService backpackerAdminService;

    @PreAuthorize("@ss.hasPermi('backpacker:coin:list')")
    @GetMapping("/list")
    public TableDataInfo list(BizCoinTransaction transaction)
    {
        startPage();
        List<BizCoinTransaction> list = backpackerAdminService.selectCoinTransactionList(transaction);
        return getDataTable(list);
    }
}
