package com.iwip.common.core.domain.model;

/**
 * Login pengguna Backpacker (mobile, tanpa captcha).
 */
public class BackpackerLoginBody
{
    private String username;

    private String password;

    public String getUsername()
    {
        return username;
    }

    public void setUsername(String username)
    {
        this.username = username;
    }

    public String getPassword()
    {
        return password;
    }

    public void setPassword(String password)
    {
        this.password = password;
    }
}
