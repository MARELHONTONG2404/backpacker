package com.iwip.common.core.domain.model;

/**
 * Update profil backpacker (mobile).
 */
public class BackpackerProfileUpdateBody
{
    private String nickName;

    private String phonenumber;

    public String getNickName()
    {
        return nickName;
    }

    public void setNickName(String nickName)
    {
        this.nickName = nickName;
    }

    public String getPhonenumber()
    {
        return phonenumber;
    }

    public void setPhonenumber(String phonenumber)
    {
        this.phonenumber = phonenumber;
    }
}
