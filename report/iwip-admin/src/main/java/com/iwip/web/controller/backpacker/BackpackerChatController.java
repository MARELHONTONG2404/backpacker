package com.iwip.web.controller.backpacker;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.iwip.common.core.controller.BaseController;
import com.iwip.common.core.domain.AjaxResult;
import com.iwip.system.service.IBackpackerChatService;

/**
 * API ringkas chat backpacker untuk mobile.
 */
@RestController
@RequestMapping("/backpacker/chat")
public class BackpackerChatController extends BaseController
{
    @Autowired
    private IBackpackerChatService chatService;

    @GetMapping("/unread-count")
    public AjaxResult unreadCount()
    {
        AjaxResult ajax = AjaxResult.success();
        ajax.put("unreadCount", chatService.countTotalUnread(getUserId()));
        return ajax;
    }
}
