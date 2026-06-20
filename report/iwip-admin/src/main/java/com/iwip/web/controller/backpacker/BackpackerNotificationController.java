package com.iwip.web.controller.backpacker;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.iwip.common.core.controller.BaseController;
import com.iwip.common.core.domain.AjaxResult;
import com.iwip.system.domain.BizBackpackerNotification;
import com.iwip.system.service.IBackpackerNotificationService;

/**
 * API notifikasi in-app Backpacker untuk mobile.
 */
@RestController
@RequestMapping("/backpacker/notifications")
public class BackpackerNotificationController extends BaseController
{
    @Autowired
    private IBackpackerNotificationService notificationService;

    @GetMapping
    public AjaxResult list(@RequestParam(defaultValue = "20") int limit)
    {
        List<BizBackpackerNotification> list = notificationService.listForUser(getUserId(), limit);
        AjaxResult ajax = AjaxResult.success(list);
        ajax.put("unreadCount", notificationService.countUnread(getUserId()));
        return ajax;
    }

    @GetMapping("/unread-count")
    public AjaxResult unreadCount()
    {
        AjaxResult ajax = AjaxResult.success();
        ajax.put("unreadCount", notificationService.countUnread(getUserId()));
        return ajax;
    }

    @PostMapping("/{notificationId}/read")
    public AjaxResult markRead(@PathVariable Long notificationId)
    {
        notificationService.markAsRead(getUserId(), notificationId);
        return success();
    }

    @PostMapping("/read-all")
    public AjaxResult markAllRead()
    {
        notificationService.markAllAsRead(getUserId());
        return success("Semua notifikasi ditandai sudah dibaca");
    }
}
