package com.iwip.common.core.domain.model;

/**
 * Body kirim pesan chat per pesanan.
 */
public class BackpackerChatMessageBody
{
    private String content;

    private String imageUrl;

    public String getContent()
    {
        return content;
    }

    public void setContent(String content)
    {
        this.content = content;
    }

    public String getImageUrl()
    {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl)
    {
        this.imageUrl = imageUrl;
    }
}
