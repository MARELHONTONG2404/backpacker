package com.iwip.system.domain;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.iwip.common.annotation.Excel;
import com.iwip.common.core.domain.BaseEntity;

/**
 * Laporan bisnis biz_report
 */
public class BizReport extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long reportId;

    @Excel(name = "Nomor Laporan")
    private String reportNo;

    @Excel(name = "Judul")
    private String title;

    @Excel(name = "Tipe", readConverterExp = "1=Harian,2=Insiden,3=Maintenance")
    private String reportType;

    @Excel(name = "Status", readConverterExp = "0=Draft,1=Diajukan,2=Disetujui,3=Ditolak")
    private String status;

    @Excel(name = "Isi Laporan")
    private String content;

    private Long userId;

    private Long deptId;

    private String delFlag;

    /** Nama pelapor (join) */
    @Excel(name = "Pelapor")
    private String nickName;

    /** Nama departemen (join) */
    @Excel(name = "Departemen")
    private String deptName;

    public Long getReportId()
    {
        return reportId;
    }

    public void setReportId(Long reportId)
    {
        this.reportId = reportId;
    }

  public String getReportNo()
    {
        return reportNo;
    }

    public void setReportNo(String reportNo)
    {
        this.reportNo = reportNo;
    }

    @NotBlank(message = "Judul laporan tidak boleh kosong")
    @Size(max = 200, message = "Judul laporan maksimal 200 karakter")
    public String getTitle()
    {
        return title;
    }

    public void setTitle(String title)
    {
        this.title = title;
    }

    @NotBlank(message = "Tipe laporan tidak boleh kosong")
    public String getReportType()
    {
        return reportType;
    }

    public void setReportType(String reportType)
    {
        this.reportType = reportType;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    public String getContent()
    {
        return content;
    }

    public void setContent(String content)
    {
        this.content = content;
    }

    public Long getUserId()
    {
        return userId;
    }

    public void setUserId(Long userId)
    {
        this.userId = userId;
    }

    public Long getDeptId()
    {
        return deptId;
    }

    public void setDeptId(Long deptId)
    {
        this.deptId = deptId;
    }

    public String getDelFlag()
    {
        return delFlag;
    }

    public void setDelFlag(String delFlag)
    {
        this.delFlag = delFlag;
    }

    public String getNickName()
    {
        return nickName;
    }

    public void setNickName(String nickName)
    {
        this.nickName = nickName;
    }

    public String getDeptName()
    {
        return deptName;
    }

    public void setDeptName(String deptName)
    {
        this.deptName = deptName;
    }

    @Override
    public String toString()
    {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("reportId", getReportId())
            .append("reportNo", getReportNo())
            .append("title", getTitle())
            .append("reportType", getReportType())
            .append("status", getStatus())
            .append("content", getContent())
            .append("userId", getUserId())
            .append("deptId", getDeptId())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("remark", getRemark())
            .toString();
    }
}
