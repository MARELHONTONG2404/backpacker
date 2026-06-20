package com.iwip.common.constant;

/**
 * Konstanta bisnis modul Backpacker (koin & reputasi).
 */
public final class BackpackerConstants
{
    private BackpackerConstants()
    {
    }

    /** Bonus koin saat registrasi. */
    public static final int REGISTER_BONUS_COINS = 10;

    /** Biaya publikasi satu tugas (koin tembaga). */
    public static final int PUBLISH_FEE_COINS = 5;

    /** Reward check-in harian. */
    public static final int DAILY_CHECKIN_COINS = 2;

    /** Reward menyelesaikan tugas. */
    public static final int TASK_REWARD_COINS = 3;

    /** Skor reputasi awal. */
    public static final int INITIAL_REPUTATION = 100;

    /** Batas minimum reputasi untuk menerima tugas. */
    public static final int MIN_REPUTATION_TO_TAKE = 60;

    /** Batas skor reputasi. */
    public static final int REPUTATION_MIN = 0;
    public static final int REPUTATION_MAX = 200;

    /** Perubahan reputasi per peristiwa. */
    public static final int REPUTATION_TASK_COMPLETE = 5;
    public static final int REPUTATION_TASK_FAILED = -10;
    public static final int REPUTATION_BAD_RATING = -8;
    public static final int REPUTATION_GOOD_RATING = 3;

    /** Skor penilaian buruk / bagus. */
    public static final int RATING_BAD_MAX = 2;
    public static final int RATING_GOOD_MIN = 4;

    public static final String TX_REGISTER_BONUS = "REGISTER_BONUS";
    public static final String TX_DAILY_CHECKIN = "DAILY_CHECKIN";
    public static final String TX_PUBLISH_FEE = "PUBLISH_FEE";
    public static final String TX_TASK_REWARD = "TASK_REWARD";

    public static final String REP_TASK_COMPLETE = "TASK_COMPLETE";
    public static final String REP_TASK_FAILED = "TASK_FAILED";
    public static final String REP_BAD_RATING = "BAD_RATING";
    public static final String REP_GOOD_RATING = "GOOD_RATING";
}
