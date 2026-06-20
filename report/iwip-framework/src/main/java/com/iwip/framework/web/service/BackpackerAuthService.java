package com.iwip.framework.web.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import com.iwip.common.constant.Constants;
import com.iwip.common.constant.UserConstants;
import com.iwip.common.core.domain.entity.SysUser;
import com.iwip.common.core.domain.model.BackpackerRegisterBody;
import com.iwip.common.utils.DateUtils;
import com.iwip.common.utils.SecurityUtils;
import com.iwip.common.utils.StringUtils;
import com.iwip.system.service.IBackpackerCoinService;
import com.iwip.system.service.ISysUserService;

/**
 * Autentikasi pengguna Backpacker (registrasi + login mobile).
 */
@Component
public class BackpackerAuthService
{
    private static final Long BACKPACKER_ROLE_ID = 3L;
    private static final int PHONENUMBER_MAX_LENGTH = 20;

    @Autowired
    private ISysUserService userService;

    @Autowired
    private IBackpackerCoinService backpackerCoinService;

    @Autowired
    private SysLoginService loginService;

    @Transactional
    public SysUser register(BackpackerRegisterBody body)
    {
        String username = StringUtils.trim(body.getUsername());
        String password = body.getPassword();
        String nickName = StringUtils.trim(body.getNickName());
        String phonenumber = StringUtils.trim(body.getPhonenumber());

        validateRegisterInput(username, password);

        SysUser existing = new SysUser();
        existing.setUserName(username);
        if (!userService.checkUserNameUnique(existing))
        {
            throw new IllegalArgumentException("Username sudah digunakan");
        }

        if (StringUtils.isNotEmpty(phonenumber))
        {
            if (phonenumber.length() > PHONENUMBER_MAX_LENGTH)
            {
                throw new IllegalArgumentException("Nomor telepon maksimal 20 karakter");
            }
            SysUser phoneCheck = new SysUser();
            phoneCheck.setPhonenumber(phonenumber);
            if (!userService.checkPhoneUnique(phoneCheck))
            {
                throw new IllegalArgumentException("Nomor telepon sudah terdaftar");
            }
        }

        SysUser user = new SysUser();
        user.setUserName(username);
        user.setNickName(StringUtils.isNotEmpty(nickName) ? nickName : username);
        user.setPhonenumber(StringUtils.defaultString(phonenumber));
        user.setPassword(SecurityUtils.encryptPassword(password));
        user.setPwdUpdateDate(DateUtils.getNowDate());
        user.setStatus(UserConstants.NORMAL);
        user.setRoleIds(new Long[] { BACKPACKER_ROLE_ID });

        if (userService.insertUser(user) <= 0)
        {
            throw new IllegalStateException("Registrasi gagal");
        }

        backpackerCoinService.grantRegisterBonus(user.getUserId());

        user.setPassword(null);
        return user;
    }

    public String login(String username, String password, String code, String uuid)
    {
        return loginService.login(username, password, code, uuid);
    }

    private void validateRegisterInput(String username, String password)
    {
        if (StringUtils.isEmpty(username))
        {
            throw new IllegalArgumentException("Username wajib diisi");
        }
        if (StringUtils.isEmpty(password))
        {
            throw new IllegalArgumentException("Password wajib diisi");
        }
        if (username.length() < UserConstants.USERNAME_MIN_LENGTH
                || username.length() > UserConstants.USERNAME_MAX_LENGTH)
        {
            throw new IllegalArgumentException("Username harus 2-20 karakter");
        }
        if (password.length() < UserConstants.PASSWORD_MIN_LENGTH
                || password.length() > UserConstants.PASSWORD_MAX_LENGTH)
        {
            throw new IllegalArgumentException("Password harus 5-20 karakter");
        }
    }
}
