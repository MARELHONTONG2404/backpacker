package com.iwip.web.controller.backpacker;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.iwip.common.constant.Constants;
import com.iwip.common.core.controller.BaseController;
import com.iwip.common.core.domain.AjaxResult;
import com.iwip.common.core.domain.entity.SysUser;
import com.iwip.common.core.domain.model.BackpackerLoginBody;
import com.iwip.common.core.domain.model.BackpackerProfileUpdateBody;
import com.iwip.common.core.domain.model.BackpackerRegisterBody;
import com.iwip.common.core.domain.model.BackpackerResetPasswordBody;
import com.iwip.common.core.domain.model.LoginUser;
import com.iwip.common.utils.SecurityUtils;
import com.iwip.framework.web.service.BackpackerAuthService;
import com.iwip.system.service.ISysUserService;

/**
 * API autentikasi Backpacker untuk aplikasi mobile.
 */
@RestController
@RequestMapping("/backpacker/auth")
public class BackpackerAuthController extends BaseController
{
    @Autowired
    private BackpackerAuthService backpackerAuthService;

    @Autowired
    private ISysUserService userService;

    @PostMapping("/register")
    public AjaxResult register(@RequestBody BackpackerRegisterBody body)
    {
        try
        {
            SysUser user = backpackerAuthService.register(body);
            AjaxResult ajax = AjaxResult.success("Registrasi berhasil");
            ajax.put("userId", user.getUserId());
            ajax.put("username", user.getUserName());
            ajax.put("nickName", user.getNickName());
            return ajax;
        }
        catch (IllegalArgumentException ex)
        {
            return error(ex.getMessage());
        }
        catch (IllegalStateException ex)
        {
            return error(ex.getMessage());
        }
    }

    @PostMapping("/reset-password")
    public AjaxResult resetPassword(@RequestBody BackpackerResetPasswordBody body)
    {
        try
        {
            backpackerAuthService.resetPassword(body);
            return success("Password berhasil diatur ulang");
        }
        catch (IllegalArgumentException ex)
        {
            return error(ex.getMessage());
        }
        catch (IllegalStateException ex)
        {
            return error(ex.getMessage());
        }
    }

    @PostMapping("/login")
    public AjaxResult login(@RequestBody BackpackerLoginBody body)
    {
        String token = backpackerAuthService.login(
                body.getUsername(), body.getPassword(), body.getCode(), body.getUuid());
        SysUser user = userService.selectUserByUserName(body.getUsername());

        AjaxResult ajax = AjaxResult.success("Login berhasil");
        ajax.put(Constants.TOKEN, token);
        ajax.put("userId", user.getUserId());
        ajax.put("username", user.getUserName());
        ajax.put("nickName", user.getNickName());
        ajax.put("phonenumber", user.getPhonenumber());
        return ajax;
    }

    @GetMapping("/me")
    public AjaxResult profile()
    {
        LoginUser loginUser = SecurityUtils.getLoginUser();
        SysUser user = loginUser.getUser();

        AjaxResult ajax = AjaxResult.success();
        ajax.put("userId", user.getUserId());
        ajax.put("username", user.getUserName());
        ajax.put("nickName", user.getNickName());
        ajax.put("phonenumber", user.getPhonenumber());
        ajax.put("avatar", user.getAvatar());
        return ajax;
    }

    @PutMapping("/profile")
    public AjaxResult updateProfile(@RequestBody BackpackerProfileUpdateBody body)
    {
        try
        {
            SysUser user = backpackerAuthService.updateProfile(getUserId(), body);
            AjaxResult ajax = AjaxResult.success("Profil berhasil diperbarui");
            ajax.put("userId", user.getUserId());
            ajax.put("username", user.getUserName());
            ajax.put("nickName", user.getNickName());
            ajax.put("phonenumber", user.getPhonenumber());
            return ajax;
        }
        catch (IllegalArgumentException ex)
        {
            return error(ex.getMessage());
        }
        catch (IllegalStateException ex)
        {
            return error(ex.getMessage());
        }
    }
}
