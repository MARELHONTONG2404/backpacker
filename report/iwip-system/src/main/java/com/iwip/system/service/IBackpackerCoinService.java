package com.iwip.system.service;

import java.util.List;
import com.iwip.system.domain.BizBackpackerProfile;
import com.iwip.system.domain.BizCoinTransaction;

/**
 * Layanan koin tembaga & profil backpacker.
 */
public interface IBackpackerCoinService
{
    BizBackpackerProfile getOrCreateProfile(Long userId);

    BizBackpackerProfile dailyCheckin(Long userId);

    void grantRegisterBonus(Long userId);

    void chargePublishFee(Long userId, Long orderId);

    List<BizCoinTransaction> getRecentTransactions(Long userId, int limit);

    boolean canAffordPublish(Long userId);
}
