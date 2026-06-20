package com.iwip.system.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.iwip.common.core.domain.BaseEntity;

/**
 * Notifikasi in-app backpacker.
 */
public class BizBackpackerNotification extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    public static final String TYPE_ORDER_TAKEN = "ORDER_TAKEN";
    public static final String TYPE_ORDER_COMPLETED = "ORDER_COMPLETED";
    public static final String TYPE_ORDER_RATED = "ORDER_RATED";

    private Long notificationId;

    private Long userId;

    private String title;

    private String content;

    private String notifyType;

    private Long refId;

    private String isRead;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date createTime;

    public Long getNotificationId()
    {
        return notificationId;
    }

    public void setNotificationId(Long notificationId)
    {
        this.notificationId = notificationId;
    }

    public Long getUserId()
    {
        return userId;
    }

    public void setUserId(Long userId)
    {
        this.userId = userId;
    }

    public String getTitle()
    {
        return title;
    }

    public void setTitle(String title)
    {
        this.title = title;
    }

    public String getContent()
    {
        return content;
    }

    public void setContent(String content)
    {
        this.content = content;
    }

    public String getNotifyType()
    {
        return notifyType;
    }

    public void setNotifyType(String notifyType)
    {
        this.notifyType = notifyType;
    }

    public Long getRefId()
    {
        return refId;
    }

    public void setRefId(Long refId)
    {
        this.refId = refId;
    }

    public String getIsRead()
    {
        return isRead;
    }

    public void setIsRead(String isRead)
    {
        this.isRead = isRead;
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
