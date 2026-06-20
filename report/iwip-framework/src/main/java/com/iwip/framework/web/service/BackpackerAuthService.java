package com.iwip.framework.web.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import com.iwip.common.constant.UserConstants;
import com.iwip.common.core.domain.entity.SysUser;
import com.iwip.common.core.domain.model.BackpackerProfileUpdateBody;
import com.iwip.common.core.domain.model.BackpackerRegisterBody;
import com.iwip.common.core.domain.model.BackpackerResetPasswordBody;
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

        loginService.validateCaptcha(username, body.getCode(), body.getUuid());
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

    @Transactional
    public void resetPassword(BackpackerResetPasswordBody body)
    {
        String username = StringUtils.trim(body.getUsername());
        String phonenumber = StringUtils.trim(body.getPhonenumber());
        String newPassword = body.getNewPassword();

        if (StringUtils.isEmpty(username) || StringUtils.isEmpty(phonenumber))
        {
            throw new IllegalArgumentException("Username dan nomor telepon wajib diisi");
        }
        validatePassword(newPassword);

        SysUser user = userService.selectUserByUserName(username);
        if (user == null)
        {
            throw new IllegalArgumentException("Akun tidak ditemukan");
        }
        if (StringUtils.isEmpty(user.getPhonenumber())
                || !phonenumber.equals(user.getPhonenumber()))
        {
            throw new IllegalArgumentException("Nomor telepon tidak cocok dengan akun");
        }

        SysUser update = new SysUser();
        update.setUserId(user.getUserId());
        update.setPassword(SecurityUtils.encryptPassword(newPassword));
        update.setPwdUpdateDate(DateUtils.getNowDate());
        if (userService.resetUserPwd(user.getUserId(), update.getPassword()) <= 0)
        {
            throw new IllegalStateException("Gagal mengatur ulang password");
        }
    }

    @Transactional
    public SysUser updateProfile(Long userId, BackpackerProfileUpdateBody body)
    {
        SysUser user = userService.selectUserById(userId);
        if (user == null)
        {
            throw new IllegalArgumentException("Pengguna tidak ditemukan");
        }

        String nickName = StringUtils.trim(body.getNickName());
        String phonenumber = StringUtils.trim(body.getPhonenumber());

        if (StringUtils.isEmpty(nickName))
        {
            throw new IllegalArgumentException("Nama tampilan wajib diisi");
        }
        if (nickName.length() > 30)
        {
            throw new IllegalArgumentException("Nama tampilan maksimal 30 karakter");
        }
        if (StringUtils.isNotEmpty(phonenumber))
        {
            if (phonenumber.length() > PHONENUMBER_MAX_LENGTH)
            {
                throw new IllegalArgumentException("Nomor telepon maksimal 20 karakter");
            }
            SysUser phoneCheck = new SysUser();
            phoneCheck.setUserId(userId);
            phoneCheck.setPhonenumber(phonenumber);
            if (!userService.checkPhoneUnique(phoneCheck))
            {
                throw new IllegalArgumentException("Nomor telepon sudah terdaftar");
            }
        }

        SysUser update = new SysUser();
        update.setUserId(userId);
        update.setNickName(nickName);
        update.setPhonenumber(StringUtils.defaultString(phonenumber));
        if (userService.updateUserProfile(update) <= 0)
        {
            throw new IllegalStateException("Gagal memperbarui profil");
        }

        SysUser refreshed = userService.selectUserById(userId);
        refreshed.setPassword(null);
        return refreshed;
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
        validatePassword(password);
    }

    private void validatePassword(String password)
    {
        if (StringUtils.isEmpty(password))
        {
            throw new IllegalArgumentException("Password wajib diisi");
        }
        if (password.length() < UserConstants.PASSWORD_MIN_LENGTH
                || password.length() > UserConstants.PASSWORD_MAX_LENGTH)
        {
            throw new IllegalArgumentException("Password harus 5-20 karakter");
        }
    }
}
