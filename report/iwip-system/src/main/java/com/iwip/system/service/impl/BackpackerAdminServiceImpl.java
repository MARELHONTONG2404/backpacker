package com.iwip.system.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.iwip.common.exception.ServiceException;
import com.iwip.system.domain.BizBackpackerProfile;
import com.iwip.system.domain.BizCoinTransaction;
import com.iwip.system.domain.BizOrderRating;
import com.iwip.system.domain.BizReputationLog;
import com.iwip.system.mapper.BizBackpackerProfileMapper;
import com.iwip.system.mapper.BizOrderRatingMapper;
import com.iwip.system.service.IBackpackerAdminService;

/**
 * Implementasi monitoring admin Backpacker.
 */
@Service
public class BackpackerAdminServiceImpl implements IBackpackerAdminService
{
    @Autowired
    private BizBackpackerProfileMapper profileMapper;

    @Autowired
    private BizOrderRatingMapper ratingMapper;

    @Override
    public List<BizBackpackerProfile> selectProfileList(BizBackpackerProfile profile)
    {
        return profileMapper.selectProfileList(profile);
    }

    @Override
    public BizBackpackerProfile selectProfileDetail(Long userId)
    {
        BizBackpackerProfile query = new BizBackpackerProfile();
        query.setUserId(userId);
        List<BizBackpackerProfile> list = profileMapper.selectProfileList(query);
        if (list.isEmpty())
        {
            throw new ServiceException("Profil backpacker tidak ditemukan");
        }
        return list.get(0);
    }

    @Override
    public List<BizCoinTransaction> selectCoinTransactionList(BizCoinTransaction transaction)
    {
        return profileMapper.selectCoinTransactionList(transaction);
    }

    @Override
    public List<BizReputationLog> selectReputationLogList(BizReputationLog log)
    {
        return profileMapper.selectReputationLogList(log);
    }

    @Override
    public List<BizOrderRating> selectRatingList(BizOrderRating rating)
    {
        return ratingMapper.selectRatingList(rating);
    }

    @Override
    public Map<String, Object> selectGamificationStats()
    {
        List<BizBackpackerProfile> profiles = profileMapper.selectProfileList(new BizBackpackerProfile());
        long totalProfiles = profiles.size();
        long lowReputation = profiles.stream()
                .filter(p -> p.getReputationScore() != null && p.getReputationScore() < 60)
                .count();
        long totalCoins = profiles.stream()
                .mapToLong(p -> p.getCopperCoins() != null ? p.getCopperCoins() : 0)
                .sum();
        long avgReputation = totalProfiles == 0 ? 0
                : Math.round(profiles.stream()
                        .mapToInt(p -> p.getReputationScore() != null ? p.getReputationScore() : 0)
                        .average()
                        .orElse(0));

        Map<String, Object> stats = new HashMap<>();
        stats.put("totalProfiles", totalProfiles);
        stats.put("lowReputation", lowReputation);
        stats.put("totalCoins", totalCoins);
        stats.put("avgReputation", avgReputation);
        stats.put("totalRatings", ratingMapper.selectRatingList(new BizOrderRating()).size());
        return stats;
    }
}
