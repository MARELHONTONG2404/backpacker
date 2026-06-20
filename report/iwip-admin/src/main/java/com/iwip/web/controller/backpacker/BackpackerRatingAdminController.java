package com.iwip.web.controller.backpacker;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.iwip.common.core.controller.BaseController;
import com.iwip.common.core.page.TableDataInfo;
import com.iwip.system.domain.BizOrderRating;
import com.iwip.system.service.IBackpackerAdminService;

/**
 * Penilaian tugas untuk panel admin.
 */
@RestController
@RequestMapping("/backpacker/rating")
public class BackpackerRatingAdminController extends BaseController
{
    @Autowired
    private IBackpackerAdminService backpackerAdminService;

    @PreAuthorize("@ss.hasPermi('backpacker:rating:list')")
    @GetMapping("/list")
    public TableDataInfo list(BizOrderRating rating)
    {
        startPage();
        List<BizOrderRating> list = backpackerAdminService.selectRatingList(rating);
        return getDataTable(list);
    }
}
