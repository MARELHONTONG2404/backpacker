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
import com.iwip.system.domain.BizBackpackerProfile;
import com.iwip.system.domain.BizCoinTransaction;
import com.iwip.system.domain.BizOrderRating;
import com.iwip.system.domain.BizReputationLog;
import com.iwip.system.service.IBackpackerAdminService;

/**
 * Monitoring profil backpacker untuk panel admin.
 */
@RestController
@RequestMapping("/backpacker/profile")
public class BackpackerProfileAdminController extends BaseController
{
    @Autowired
    private IBackpackerAdminService backpackerAdminService;

    @PreAuthorize("@ss.hasPermi('backpacker:profile:list')")
    @GetMapping("/list")
    public TableDataInfo list(BizBackpackerProfile profile)
    {
        startPage();
        List<BizBackpackerProfile> list = backpackerAdminService.selectProfileList(profile);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('backpacker:profile:query')")
    @GetMapping("/{userId}")
    public AjaxResult getInfo(@PathVariable Long userId)
    {
        return success(backpackerAdminService.selectProfileDetail(userId));
    }

    @PreAuthorize("@ss.hasPermi('backpacker:profile:list')")
    @GetMapping("/stats")
    public AjaxResult stats()
    {
        return success(backpackerAdminService.selectGamificationStats());
    }
}
