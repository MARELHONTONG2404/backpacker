package com.iwip.web.controller.backpacker;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.iwip.common.constant.BackpackerConstants;
import com.iwip.common.core.controller.BaseController;
import com.iwip.common.core.domain.AjaxResult;
import com.iwip.common.exception.ServiceException;
import com.iwip.system.domain.BizBackpackerProfile;
import com.iwip.system.domain.BizCoinTransaction;
import com.iwip.system.service.IBackpackerCoinService;

/**
 * API koin tembaga Backpacker untuk aplikasi mobile.
 */
@RestController
@RequestMapping("/backpacker/coins")
public class BackpackerCoinController extends BaseController
{
    @Autowired
    private IBackpackerCoinService backpackerCoinService;

    @GetMapping("/profile")
    public AjaxResult profile()
    {
        BizBackpackerProfile profile = backpackerCoinService.getOrCreateProfile(getUserId());
        AjaxResult ajax = AjaxResult.success();
        ajax.put("copperCoins", profile.getCopperCoins());
        ajax.put("reputationScore", profile.getReputationScore());
        ajax.put("lastCheckinDate", profile.getLastCheckinDate());
        ajax.put("completedTasks", profile.getCompletedTasks());
        ajax.put("publishFee", BackpackerConstants.PUBLISH_FEE_COINS);
        ajax.put("dailyCheckinReward", BackpackerConstants.DAILY_CHECKIN_COINS);
        ajax.put("canCheckinToday", canCheckinToday(profile));
        ajax.put("canAffordPublish", profile.getCopperCoins() >= BackpackerConstants.PUBLISH_FEE_COINS);
        ajax.put("minReputationToTake", BackpackerConstants.MIN_REPUTATION_TO_TAKE);
        ajax.put("canTakeTask", backpackerCoinService.canTakeTask(getUserId()));
        ajax.put("taskRewardCoins", BackpackerConstants.TASK_REWARD_COINS);
        ajax.put("reputationTaskComplete", BackpackerConstants.REPUTATION_TASK_COMPLETE);
        return ajax;
    }

    @PostMapping("/checkin")
    public AjaxResult checkin()
    {
        try
        {
            BizBackpackerProfile profile = backpackerCoinService.dailyCheckin(getUserId());
            AjaxResult ajax = AjaxResult.success("Check-in berhasil! +" + BackpackerConstants.DAILY_CHECKIN_COINS + " koin tembaga");
            ajax.put("copperCoins", profile.getCopperCoins());
            ajax.put("reward", BackpackerConstants.DAILY_CHECKIN_COINS);
            return ajax;
        }
        catch (ServiceException ex)
        {
            return error(ex.getMessage());
        }
    }

    @GetMapping("/transactions")
    public AjaxResult transactions(@RequestParam(defaultValue = "20") int limit)
    {
        List<BizCoinTransaction> list = backpackerCoinService.getRecentTransactions(getUserId(), Math.min(limit, 50));
        return success(list);
    }

    private boolean canCheckinToday(BizBackpackerProfile profile)
    {
        if (profile.getLastCheckinDate() == null)
        {
            return true;
        }
        java.time.LocalDate last = profile.getLastCheckinDate().toInstant()
                .atZone(java.time.ZoneId.systemDefault()).toLocalDate();
        return !last.equals(java.time.LocalDate.now());
    }
}
