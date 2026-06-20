package com.iwip.common.core.domain.model;

/**
 * Penyesuaian koin manual oleh admin.
 */
public class BackpackerAdjustCoinsBody
{
    private Long userId;

    private Integer amount;

    private String remark;

    public Long getUserId()
    {
        return userId;
    }

    public void setUserId(Long userId)
    {
        this.userId = userId;
    }

    public Integer getAmount()
    {
        return amount;
    }

    public void setAmount(Integer amount)
    {
        this.amount = amount;
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
