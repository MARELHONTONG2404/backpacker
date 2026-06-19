package com.iwip.system.service;

import java.util.List;
import java.util.Map;
import com.iwip.system.domain.BizReport;

/**
 * Laporan 服务层
 */
public interface IBizReportService
{
    BizReport selectBizReportById(Long reportId);

    List<BizReport> selectBizReportList(BizReport report);

    int insertBizReport(BizReport report);

    int updateBizReport(BizReport report);

    int deleteBizReportByIds(Long[] reportIds);

    Map<String, Object> selectReportStats();
}
