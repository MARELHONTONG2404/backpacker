package com.iwip.system.service;

import java.util.List;
import java.util.Map;
import com.iwip.system.domain.BizBackpackerProfile;
import com.iwip.system.domain.BizCoinTransaction;
import com.iwip.system.domain.BizOrderRating;
import com.iwip.system.domain.BizReputationLog;

/**
 * Layanan monitoring admin Backpacker (profil, koin, reputasi).
 */
public interface IBackpackerAdminService
{
    List<BizBackpackerProfile> selectProfileList(BizBackpackerProfile profile);

    BizBackpackerProfile selectProfileDetail(Long userId);

    List<BizCoinTransaction> selectCoinTransactionList(BizCoinTransaction transaction);

    List<BizReputationLog> selectReputationLogList(BizReputationLog log);

    List<BizOrderRating> selectRatingList(BizOrderRating rating);

    Map<String, Object> selectGamificationStats();

    BizBackpackerProfile adjustCoins(Long userId, Integer amount, String remark, String operator);

    BizBackpackerProfile adjustReputation(Long userId, Integer delta, String remark, String operator);
}
