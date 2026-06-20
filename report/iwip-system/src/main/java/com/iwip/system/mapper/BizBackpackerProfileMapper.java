package com.iwip.system.mapper;

import java.util.Date;
import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.iwip.system.domain.BizBackpackerProfile;
import com.iwip.system.domain.BizCoinTransaction;

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
}
