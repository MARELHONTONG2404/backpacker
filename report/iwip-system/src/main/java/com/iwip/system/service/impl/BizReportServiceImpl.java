package com.iwip.system.service.impl;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.iwip.common.exception.ServiceException;
import com.iwip.common.utils.DateUtils;
import com.iwip.common.utils.MessageUtils;
import com.iwip.common.utils.SecurityUtils;
import com.iwip.common.utils.StringUtils;
import com.iwip.system.domain.BizReport;
import com.iwip.system.mapper.BizReportMapper;
import com.iwip.system.service.IBizReportService;

/**
 * Laporan 服务层实现
 */
@Service
public class BizReportServiceImpl implements IBizReportService
{
    @Autowired
    private BizReportMapper bizReportMapper;

    @Override
    public BizReport selectBizReportById(Long reportId)
    {
        return bizReportMapper.selectBizReportById(reportId);
    }

    @Override
    public List<BizReport> selectBizReportList(BizReport report)
    {
        return bizReportMapper.selectBizReportList(report);
    }

    @Override
    public int insertBizReport(BizReport report)
    {
        if (StringUtils.isEmpty(report.getReportNo()))
        {
            report.setReportNo(generateReportNo());
        }
        report.setStatus("0");
        report.setCreateTime(DateUtils.getNowDate());
        return bizReportMapper.insertBizReport(report);
    }

    @Override
    public int updateBizReport(BizReport report)
    {
        BizReport existing = bizReportMapper.selectBizReportById(report.getReportId());
        if (existing == null)
        {
            throw new ServiceException(MessageUtils.message("report.not.exists"));
        }
        String oldStatus = existing.getStatus();
        String newStatus = StringUtils.isNotEmpty(report.getStatus()) ? report.getStatus() : oldStatus;
        if (!StringUtils.equals(oldStatus, newStatus))
        {
            validateStatusTransition(oldStatus, newStatus);
        }
        else if (isContentChanged(existing, report) && isLockedStatus(oldStatus) && !SecurityUtils.isAdmin())
        {
            throw new ServiceException(MessageUtils.message("report.edit.locked"));
        }
        report.setStatus(newStatus);
        report.setUpdateTime(DateUtils.getNowDate());
        return bizReportMapper.updateBizReport(report);
    }

    @Override
    public int deleteBizReportByIds(Long[] reportIds)
    {
        return bizReportMapper.deleteBizReportByIds(reportIds);
    }

    @Override
    public Map<String, Object> selectReportStats()
    {
        Map<String, Object> stats = new HashMap<>();
        stats.put("total", bizReportMapper.countAll());
        stats.put("draft", bizReportMapper.countByStatus("0"));
        stats.put("submitted", bizReportMapper.countByStatus("1"));
        stats.put("approved", bizReportMapper.countByStatus("2"));
        stats.put("rejected", bizReportMapper.countByStatus("3"));
        stats.put("thisMonth", bizReportMapper.countThisMonth());
        stats.put("statusChart", bizReportMapper.countGroupByStatus());
        stats.put("monthlyChart", buildMonthlyChart(bizReportMapper.countGroupByMonth(6)));
        return stats;
    }

    private void validateStatusTransition(String oldStatus, String newStatus)
    {
        if (StringUtils.equals(oldStatus, newStatus))
        {
            return;
        }
        boolean allowed = ("0".equals(oldStatus) && "1".equals(newStatus))
                || ("3".equals(oldStatus) && "1".equals(newStatus))
                || ("1".equals(oldStatus) && "2".equals(newStatus))
                || ("1".equals(oldStatus) && "3".equals(newStatus));
        if (!allowed)
        {
            throw new ServiceException(MessageUtils.message("report.status.invalid"));
        }
        if ("1".equals(oldStatus) && ("2".equals(newStatus) || "3".equals(newStatus)) && !SecurityUtils.isAdmin())
        {
            throw new ServiceException(MessageUtils.message("report.status.noPermission"));
        }
    }

    private boolean isLockedStatus(String status)
    {
        return "1".equals(status) || "2".equals(status);
    }

    private boolean isContentChanged(BizReport existing, BizReport report)
    {
        return (report.getTitle() != null && !StringUtils.equals(existing.getTitle(), report.getTitle()))
                || (report.getReportType() != null && !StringUtils.equals(existing.getReportType(), report.getReportType()))
                || (report.getContent() != null && !StringUtils.equals(existing.getContent(), report.getContent()))
                || (report.getRemark() != null && !StringUtils.equals(existing.getRemark(), report.getRemark()));
    }

    private String generateReportNo()
    {
        String datePart = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        return "RPT-" + datePart + "-" + String.format("%04d", System.currentTimeMillis() % 10000);
    }

    private List<Map<String, Object>> buildMonthlyChart(List<Map<String, Object>> dbRows)
    {
        Map<String, Long> countMap = new HashMap<>();
        for (Map<String, Object> row : dbRows)
        {
            Object month = row.get("month");
            Object count = row.get("count");
            if (month != null && count != null)
            {
                countMap.put(month.toString(), Long.parseLong(count.toString()));
            }
        }
        List<Map<String, Object>> result = new ArrayList<>();
        LocalDate now = LocalDate.now();
        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM");
        for (int i = 5; i >= 0; i--)
        {
            String month = now.minusMonths(i).format(fmt);
            Map<String, Object> item = new HashMap<>();
            item.put("month", month);
            item.put("count", countMap.getOrDefault(month, 0L));
            result.add(item);
        }
        return result;
    }
}
