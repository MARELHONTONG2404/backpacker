package com.iwip.common.core.domain.model;

/**
 * Body tandai chat sudah dibaca.
 */
public class BackpackerChatReadBody
{
    private Long lastMessageId;

    public Long getLastMessageId()
    {
        return lastMessageId;
    }

    public void setLastMessageId(Long lastMessageId)
    {
        this.lastMessageId = lastMessageId;
    }
}
