package com.iwip.common.core.domain.model;

/**
 * Penyesuaian reputasi manual oleh admin.
 */
public class BackpackerAdjustReputationBody
{
    private Long userId;

    private Integer delta;

    private String remark;

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

    public String getRemark()
    {
        return remark;
    }

    public void setRemark(String remark)
    {
        this.remark = remark;
    }
}
