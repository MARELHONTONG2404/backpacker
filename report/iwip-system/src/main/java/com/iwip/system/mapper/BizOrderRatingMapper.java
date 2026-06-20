package com.iwip.system.mapper;

import com.iwip.system.domain.BizOrderRating;

/**
 * Penilaian tugas data layer.
 */
public interface BizOrderRatingMapper
{
    BizOrderRating selectRatingByOrderId(Long orderId);

    int insertRating(BizOrderRating rating);
}
