package com.iwip.web.controller.backpacker;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.iwip.common.core.controller.BaseController;
import com.iwip.common.core.domain.AjaxResult;
import com.iwip.common.core.domain.model.BackpackerChatMessageBody;
import com.iwip.common.core.domain.model.BackpackerChatReadBody;
import com.iwip.common.exception.ServiceException;
import com.iwip.system.domain.BizBackpackerChatMessage;
import com.iwip.system.service.IBackpackerChatService;

/**
 * API chat per pesanan Backpacker untuk aplikasi mobile.
 */
@RestController
@RequestMapping("/backpacker/orders")
public class BackpackerOrderChatController extends BaseController
{
    @Autowired
    private IBackpackerChatService chatService;

    @GetMapping("/{orderId}/messages")
    public AjaxResult list(@PathVariable Long orderId,
            @RequestParam(defaultValue = "50") int limit,
            @RequestParam(required = false) Long sinceId)
    {
        try
        {
            List<BizBackpackerChatMessage> messages = chatService.listMessages(orderId, getUserId(), limit, sinceId);
            return success(messages);
        }
        catch (ServiceException ex)
        {
            return error(ex.getMessage());
        }
    }

    @GetMapping("/{orderId}/messages/unread-count")
    public AjaxResult unreadCount(@PathVariable Long orderId)
    {
        try
        {
            AjaxResult ajax = AjaxResult.success();
            ajax.put("unreadCount", chatService.countUnreadForOrder(orderId, getUserId()));
            return ajax;
        }
        catch (ServiceException ex)
        {
            return error(ex.getMessage());
        }
    }

    @PostMapping("/{orderId}/messages/read")
    public AjaxResult markRead(@PathVariable Long orderId, @RequestBody(required = false) BackpackerChatReadBody body)
    {
        try
        {
            Long lastMessageId = body != null ? body.getLastMessageId() : null;
            chatService.markAsRead(orderId, getUserId(), lastMessageId);
            return success();
        }
        catch (ServiceException ex)
        {
            return error(ex.getMessage());
        }
    }

    @PostMapping("/{orderId}/messages")
    public AjaxResult send(@PathVariable Long orderId, @RequestBody BackpackerChatMessageBody body)
    {
        try
        {
            String content = body != null ? body.getContent() : null;
            String imageUrl = body != null ? body.getImageUrl() : null;
            BizBackpackerChatMessage message = chatService.sendMessage(
                    orderId, getUserId(), getUsername(), content, imageUrl);
            return AjaxResult.success("Pesan terkirim", message);
        }
        catch (ServiceException ex)
        {
            return error(ex.getMessage());
        }
    }
}
