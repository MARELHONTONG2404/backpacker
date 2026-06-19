package com.iwip.system.domain;

import java.math.BigDecimal;
import java.util.Date;
import javax.validation.constraints.DecimalMin;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.iwip.common.core.domain.BaseEntity;

/**
 * Pesanan marketplace biz_order.
 */
public class BizOrder extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    public static final String STATUS_DRAFT = "DRAFT";
    public static final String STATUS_PUBLISHED = "PUBLISHED";
    public static final String STATUS_TAKEN = "TAKEN";
    public static final String STATUS_IN_PROGRESS = "IN_PROGRESS";
    public static final String STATUS_COMPLETED = "COMPLETED";
    public static final String STATUS_CANCELLED = "CANCELLED";
    public static final String STATUS_EXPIRED = "EXPIRED";

    private Long orderId;

    private String orderNo;

    private String title;

    private String description;

    private String category;

    private BigDecimal rewardAmount;

    private String locationText;

    private Long creatorId;

    private Long executorId;

    private String status;

    private Integer version;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date publishedAt;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date takenAt;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date startedAt;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date completedAt;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date cancelledAt;

    private String cancelReason;

    private String delFlag;

    private String creatorName;

    private String executorName;

    public Long getOrderId()
    {
        return orderId;
    }

    public void setOrderId(Long orderId)
    {
        this.orderId = orderId;
    }

    public String getOrderNo()
    {
        return orderNo;
    }

    public void setOrderNo(String orderNo)
    {
        this.orderNo = orderNo;
    }

    @NotBlank(message = "Judul tugas wajib diisi")
    @Size(max = 200, message = "Judul tugas maksimal 200 karakter")
    public String getTitle()
    {
        return title;
    }

    public void setTitle(String title)
    {
        this.title = title;
    }

    public String getDescription()
    {
        return description;
    }

    public void setDescription(String description)
    {
        this.description = description;
    }

    @Size(max = 50, message = "Kategori maksimal 50 karakter")
    public String getCategory()
    {
        return category;
    }

    public void setCategory(String category)
    {
        this.category = category;
    }

    @NotNull(message = "Imbalan wajib diisi")
    @DecimalMin(value = "0.00", message = "Imbalan tidak boleh negatif")
    public BigDecimal getRewardAmount()
    {
        return rewardAmount;
    }

    public void setRewardAmount(BigDecimal rewardAmount)
    {
        this.rewardAmount = rewardAmount;
    }

    @Size(max = 255, message = "Lokasi maksimal 255 karakter")
    public String getLocationText()
    {
        return locationText;
    }

    public void setLocationText(String locationText)
    {
        this.locationText = locationText;
    }

    public Long getCreatorId()
    {
        return creatorId;
    }

    public void setCreatorId(Long creatorId)
    {
        this.creatorId = creatorId;
    }

    public Long getExecutorId()
    {
        return executorId;
    }

    public void setExecutorId(Long executorId)
    {
        this.executorId = executorId;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    public Integer getVersion()
    {
        return version;
    }

    public void setVersion(Integer version)
    {
        this.version = version;
    }

    public Date getPublishedAt()
    {
        return publishedAt;
    }

    public void setPublishedAt(Date publishedAt)
    {
        this.publishedAt = publishedAt;
    }

    public Date getTakenAt()
    {
        return takenAt;
    }

    public void setTakenAt(Date takenAt)
    {
        this.takenAt = takenAt;
    }

    public Date getStartedAt()
    {
        return startedAt;
    }

    public void setStartedAt(Date startedAt)
    {
        this.startedAt = startedAt;
    }

    public Date getCompletedAt()
    {
        return completedAt;
    }

    public void setCompletedAt(Date completedAt)
    {
        this.completedAt = completedAt;
    }

    public Date getCancelledAt()
    {
        return cancelledAt;
    }

    public void setCancelledAt(Date cancelledAt)
    {
        this.cancelledAt = cancelledAt;
    }

    public String getCancelReason()
    {
        return cancelReason;
    }

    public void setCancelReason(String cancelReason)
    {
        this.cancelReason = cancelReason;
    }

    public String getDelFlag()
    {
        return delFlag;
    }

    public void setDelFlag(String delFlag)
    {
        this.delFlag = delFlag;
    }

    public String getCreatorName()
    {
        return creatorName;
    }

    public void setCreatorName(String creatorName)
    {
        this.creatorName = creatorName;
    }

    public String getExecutorName()
    {
        return executorName;
    }

    public void setExecutorName(String executorName)
    {
        this.executorName = executorName;
    }
}
