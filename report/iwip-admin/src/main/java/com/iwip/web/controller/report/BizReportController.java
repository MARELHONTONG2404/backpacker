package com.iwip.web.controller.report;

import java.util.List;
import javax.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.iwip.common.annotation.Log;
import com.iwip.common.core.controller.BaseController;
import com.iwip.common.core.domain.AjaxResult;
import com.iwip.common.core.domain.entity.SysUser;
import com.iwip.common.core.page.TableDataInfo;
import com.iwip.common.enums.BusinessType;
import com.iwip.common.utils.SecurityUtils;
import com.iwip.common.utils.poi.ExcelUtil;
import com.iwip.system.domain.BizReport;
import com.iwip.system.service.IBizReportService;

/**
 * Laporan IWIP
 */
@RestController
@RequestMapping("/report/report")
public class BizReportController extends BaseController
{
    @Autowired
    private IBizReportService bizReportService;

    @PreAuthorize("@ss.hasPermi('report:report:list')")
    @GetMapping("/list")
    public TableDataInfo list(BizReport report)
    {
        startPage();
        List<BizReport> list = bizReportService.selectBizReportList(report);
        return getDataTable(list);
    }

    @Log(title = "Laporan", businessType = BusinessType.EXPORT)
    @PreAuthorize("@ss.hasPermi('report:report:export')")
    @PostMapping("/export")
    public void export(HttpServletResponse response, BizReport report)
    {
        List<BizReport> list = bizReportService.selectBizReportList(report);
        ExcelUtil<BizReport> util = new ExcelUtil<BizReport>(BizReport.class);
        util.exportExcel(response, list, "Data Laporan");
    }

    @PreAuthorize("@ss.hasPermi('report:report:query')")
    @GetMapping("/{reportId}")
    public AjaxResult getInfo(@PathVariable Long reportId)
    {
        return success(bizReportService.selectBizReportById(reportId));
    }

    @GetMapping("/stats")
    public AjaxResult stats()
    {
        return success(bizReportService.selectReportStats());
    }

    @PreAuthorize("@ss.hasPermi('report:report:add')")
    @Log(title = "Laporan", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody BizReport report)
    {
        SysUser user = SecurityUtils.getLoginUser().getUser();
        report.setUserId(user.getUserId());
        report.setDeptId(user.getDeptId());
        report.setCreateBy(getUsername());
        return toAjax(bizReportService.insertBizReport(report));
    }

    @PreAuthorize("@ss.hasPermi('report:report:edit')")
    @Log(title = "Laporan", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody BizReport report)
    {
        report.setUpdateBy(getUsername());
        return toAjax(bizReportService.updateBizReport(report));
    }

    @PreAuthorize("@ss.hasPermi('report:report:remove')")
    @Log(title = "Laporan", businessType = BusinessType.DELETE)
    @DeleteMapping("/{reportIds}")
    public AjaxResult remove(@PathVariable Long[] reportIds)
    {
        return toAjax(bizReportService.deleteBizReportByIds(reportIds));
    }
}
