package com.iwip.system.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;

/**
 * Log perubahan reputasi biz_reputation_log.
 */
public class BizReputationLog
{
    private Long logId;

    private Long userId;

    private Integer delta;

    private Integer scoreAfter;

    private String reason;

    private Long refId;

    private String remark;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date createTime;

    public Long getLogId()
    {
        return logId;
    }

    public void setLogId(Long logId)
    {
        this.logId = logId;
    }

    public Long getUserId()
    {
        return userId;
    }

    public void setUserId(Long userId)
    {
        this.userId = userId;
    }

    public Integer getDelta()
    {
        return delta;
    }

    public void setDelta(Integer delta)
    {
        this.delta = delta;
    }

    public Integer getScoreAfter()
    {
        return scoreAfter;
    }

    public void setScoreAfter(Integer scoreAfter)
    {
        this.scoreAfter = scoreAfter;
    }

    public String getReason()
    {
        return reason;
    }

    public void setReason(String reason)
    {
        this.reason = reason;
    }

    public Long getRefId()
    {
        return refId;
    }

    public void setRefId(Long refId)
    {
        this.refId = refId;
    }

    public String getRemark()
    {
        return remark;
    }

    public void setRemark(String remark)
    {
        this.remark = remark;
    }

    public Date getCreateTime()
    {
        return createTime;
    }

    public void setCreateTime(Date createTime)
    {
        this.createTime = createTime;
    }
}
