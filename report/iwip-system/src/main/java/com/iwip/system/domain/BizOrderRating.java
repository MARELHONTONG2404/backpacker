package com.iwip.system.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.iwip.common.core.domain.BaseEntity;

/**
 * Penilaian tugas biz_order_rating.
 */
public class BizOrderRating extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long ratingId;

    private Long orderId;

    private Long raterId;

    private Long executorId;

    private Integer score;

    private String comment;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date createTime;

    private String orderNo;

    private String orderTitle;

    private String raterName;

    private String executorName;

    public Long getRatingId()
    {
        return ratingId;
    }

    public void setRatingId(Long ratingId)
    {
        this.ratingId = ratingId;
    }

    public Long getOrderId()
    {
        return orderId;
    }

    public void setOrderId(Long orderId)
    {
        this.orderId = orderId;
    }

    public Long getRaterId()
    {
        return raterId;
    }

    public void setRaterId(Long raterId)
    {
        this.raterId = raterId;
    }

    public Long getExecutorId()
    {
        return executorId;
    }

    public void setExecutorId(Long executorId)
    {
        this.executorId = executorId;
    }

    public Integer getScore()
    {
        return score;
    }

    public void setScore(Integer score)
    {
        this.score = score;
    }

    public String getComment()
    {
        return comment;
    }

    public void setComment(String comment)
    {
        this.comment = comment;
    }

    public Date getCreateTime()
    {
        return createTime;
    }

    public void setCreateTime(Date createTime)
    {
        this.createTime = createTime;
    }

    public String getOrderNo()
    {
        return orderNo;
    }

    public void setOrderNo(String orderNo)
    {
        this.orderNo = orderNo;
    }

    public String getOrderTitle()
    {
        return orderTitle;
    }

    public void setOrderTitle(String orderTitle)
    {
        this.orderTitle = orderTitle;
    }

    public String getRaterName()
    {
        return raterName;
    }

    public void setRaterName(String raterName)
    {
        this.raterName = raterName;
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
