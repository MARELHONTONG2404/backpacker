package com.iwip.web.controller.backpacker;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.iwip.common.core.controller.BaseController;
import com.iwip.common.core.domain.AjaxResult;
import com.iwip.common.exception.ServiceException;
import com.iwip.system.domain.BizBackpackerChatMessage;
import com.iwip.system.service.IBackpackerChatService;

/**
 * Monitoring chat backpacker untuk panel admin.
 */
@RestController
@RequestMapping("/backpacker/chat")
public class BackpackerChatAdminController extends BaseController
{
    @Autowired
    private IBackpackerChatService chatService;

    @PreAuthorize("@ss.hasPermi('backpacker:order:query')")
    @GetMapping("/order/{orderId}/messages")
    public AjaxResult list(@PathVariable Long orderId, @RequestParam(defaultValue = "200") int limit)
    {
        try
        {
            List<BizBackpackerChatMessage> messages = chatService.listMessagesForAdmin(orderId, limit);
            return success(messages);
        }
        catch (ServiceException ex)
        {
            return error(ex.getMessage());
        }
    }
}
