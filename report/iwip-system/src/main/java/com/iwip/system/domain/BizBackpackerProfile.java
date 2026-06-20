package com.iwip.system.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;

/**
 * Profil backpacker (koin tembaga & reputasi).
 */
public class BizBackpackerProfile
{
    private Long userId;

    private Integer copperCoins;

    private Integer reputationScore;

    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date lastCheckinDate;

    private Integer completedTasks;

    private Integer failedTasks;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date createTime;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date updateTime;

    public Long getUserId()
    {
        return userId;
    }

    public void setUserId(Long userId)
    {
        this.userId = userId;
    }

    public Integer getCopperCoins()
    {
        return copperCoins;
    }

    public void setCopperCoins(Integer copperCoins)
    {
        this.copperCoins = copperCoins;
    }

    public Integer getReputationScore()
    {
        return reputationScore;
    }

    public void setReputationScore(Integer reputationScore)
    {
        this.reputationScore = reputationScore;
    }

    public Date getLastCheckinDate()
    {
        return lastCheckinDate;
    }

    public void setLastCheckinDate(Date lastCheckinDate)
    {
        this.lastCheckinDate = lastCheckinDate;
    }

    public Integer getCompletedTasks()
    {
        return completedTasks;
    }

    public void setCompletedTasks(Integer completedTasks)
    {
        this.completedTasks = completedTasks;
    }

    public Integer getFailedTasks()
    {
        return failedTasks;
    }

    public void setFailedTasks(Integer failedTasks)
    {
        this.failedTasks = failedTasks;
    }

    public Date getCreateTime()
    {
        return createTime;
    }

    public void setCreateTime(Date createTime)
    {
        this.createTime = createTime;
    }

    public Date getUpdateTime()
    {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime)
    {
        this.updateTime = updateTime;
    }
}
