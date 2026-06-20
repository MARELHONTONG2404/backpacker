package com.iwip.system.service.impl;

import java.time.LocalDate;
import java.time.ZoneId;
import java.util.Date;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.iwip.common.constant.BackpackerConstants;
import com.iwip.common.exception.ServiceException;
import com.iwip.common.utils.DateUtils;
import com.iwip.system.domain.BizBackpackerProfile;
import com.iwip.system.domain.BizCoinTransaction;
import com.iwip.system.mapper.BizBackpackerProfileMapper;
import com.iwip.system.service.IBackpackerCoinService;

/**
 * Implementasi layanan koin tembaga backpacker.
 */
@Service
public class BackpackerCoinServiceImpl implements IBackpackerCoinService
{
    @Autowired
    private BizBackpackerProfileMapper profileMapper;

    @Override
    public BizBackpackerProfile getOrCreateProfile(Long userId)
    {
        BizBackpackerProfile profile = profileMapper.selectProfileByUserId(userId);
        if (profile != null)
        {
            return profile;
        }

        profile = new BizBackpackerProfile();
        profile.setUserId(userId);
        profile.setCopperCoins(0);
        profile.setReputationScore(BackpackerConstants.INITIAL_REPUTATION);
        profile.setCompletedTasks(0);
        profile.setFailedTasks(0);
        profile.setCreateTime(DateUtils.getNowDate());
        profile.setUpdateTime(DateUtils.getNowDate());
        profileMapper.insertProfile(profile);
        return profileMapper.selectProfileByUserId(userId);
    }

    @Override
    @Transactional
    public BizBackpackerProfile dailyCheckin(Long userId)
    {
        BizBackpackerProfile profile = getOrCreateProfile(userId);
        LocalDate today = LocalDate.now();
        if (profile.getLastCheckinDate() != null)
        {
            LocalDate lastCheckin = profile.getLastCheckinDate().toInstant()
                    .atZone(ZoneId.systemDefault()).toLocalDate();
            if (lastCheckin.equals(today))
            {
                throw new ServiceException("Anda sudah check-in hari ini");
            }
        }

        creditCoins(userId, BackpackerConstants.DAILY_CHECKIN_COINS,
                BackpackerConstants.TX_DAILY_CHECKIN, null, "Check-in harian");

        Date todayDate = Date.from(today.atStartOfDay(ZoneId.systemDefault()).toInstant());
        profileMapper.updateLastCheckinDate(userId, todayDate);
        return profileMapper.selectProfileByUserId(userId);
    }

    @Override
    @Transactional
    public void grantRegisterBonus(Long userId)
    {
        getOrCreateProfile(userId);
        creditCoins(userId, BackpackerConstants.REGISTER_BONUS_COINS,
                BackpackerConstants.TX_REGISTER_BONUS, null, "Bonus registrasi backpacker");
    }

    @Override
    @Transactional
    public void chargePublishFee(Long userId, Long orderId)
    {
        int fee = BackpackerConstants.PUBLISH_FEE_COINS;
        BizBackpackerProfile profile = getOrCreateProfile(userId);
        if (profile.getCopperCoins() < fee)
        {
            throw new ServiceException("Koin tembaga tidak cukup. Biaya publikasi: "
                    + fee + " koin, saldo Anda: " + profile.getCopperCoins() + " koin");
        }

        if (profileMapper.deductCoins(userId, fee) <= 0)
        {
            throw new ServiceException("Gagal memotong koin tembaga untuk publikasi");
        }

        BizBackpackerProfile updated = profileMapper.selectProfileByUserId(userId);
        insertTransaction(userId, -fee, updated.getCopperCoins(),
                BackpackerConstants.TX_PUBLISH_FEE, orderId, "Biaya publikasi tugas");
    }

    @Override
    public List<BizCoinTransaction> getRecentTransactions(Long userId, int limit)
    {
        getOrCreateProfile(userId);
        return profileMapper.selectRecentTransactions(userId, limit);
    }

    @Override
    public boolean canAffordPublish(Long userId)
    {
        BizBackpackerProfile profile = getOrCreateProfile(userId);
        return profile.getCopperCoins() >= BackpackerConstants.PUBLISH_FEE_COINS;
    }

    private void creditCoins(Long userId, int amount, String txType, Long refId, String remark)
    {
        if (profileMapper.addCoins(userId, amount) <= 0)
        {
            throw new ServiceException("Gagal menambah koin tembaga");
        }
        BizBackpackerProfile updated = profileMapper.selectProfileByUserId(userId);
        insertTransaction(userId, amount, updated.getCopperCoins(), txType, refId, remark);
    }

    private void insertTransaction(Long userId, int amount, int balanceAfter,
            String txType, Long refId, String remark)
    {
        BizCoinTransaction tx = new BizCoinTransaction();
        tx.setUserId(userId);
        tx.setAmount(amount);
        tx.setBalanceAfter(balanceAfter);
        tx.setTxType(txType);
        tx.setRefId(refId);
        tx.setRemark(remark);
        tx.setCreateTime(DateUtils.getNowDate());
        profileMapper.insertCoinTransaction(tx);
    }
}
