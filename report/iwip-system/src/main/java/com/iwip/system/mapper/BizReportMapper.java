package com.iwip.system.mapper;

import java.util.List;
import java.util.Map;
import com.iwip.system.domain.BizReport;

/**
 * Laporan 数据层
 */
public interface BizReportMapper
{
    BizReport selectBizReportById(Long reportId);

    List<BizReport> selectBizReportList(BizReport report);

    int insertBizReport(BizReport report);

    int updateBizReport(BizReport report);

    int deleteBizReportByIds(Long[] reportIds);

    int countAll();

    int countByStatus(String status);

    int countThisMonth();

    List<Map<String, Object>> countGroupByStatus();

    List<Map<String, Object>> countGroupByMonth(int months);
}
