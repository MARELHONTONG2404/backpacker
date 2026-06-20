package com.iwip.system.mapper;

import java.util.Date;
import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.iwip.system.domain.BizBackpackerProfile;
import com.iwip.system.domain.BizCoinTransaction;
import com.iwip.system.domain.BizReputationLog;

/**
 * Profil backpacker & transaksi koin data layer.
 */
public interface BizBackpackerProfileMapper
{
    BizBackpackerProfile selectProfileByUserId(Long userId);

    int insertProfile(BizBackpackerProfile profile);

    int addCoins(@Param("userId") Long userId, @Param("amount") int amount);

    int deductCoins(@Param("userId") Long userId, @Param("amount") int amount);

    int updateLastCheckinDate(@Param("userId") Long userId, @Param("checkinDate") Date checkinDate);

    int insertCoinTransaction(BizCoinTransaction transaction);

    List<BizCoinTransaction> selectRecentTransactions(@Param("userId") Long userId, @Param("limit") int limit);

    int adjustReputationScore(@Param("userId") Long userId, @Param("delta") int delta);

    int incrementCompletedTasks(@Param("userId") Long userId);

    int incrementFailedTasks(@Param("userId") Long userId);

    int insertReputationLog(BizReputationLog log);

    List<BizBackpackerProfile> selectProfileList(BizBackpackerProfile profile);

    List<BizCoinTransaction> selectCoinTransactionList(BizCoinTransaction transaction);

    List<BizReputationLog> selectReputationLogList(BizReputationLog log);
}
