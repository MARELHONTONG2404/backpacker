package com.iwip.common.core.domain.model;

/**
 * Body penilaian tugas oleh pembuat.
 */
public class BackpackerOrderRateBody
{
    private Integer score;

    private String comment;

    public Integer getScore()
    {
        return score;
    }

    public void setScore(Integer score)
    {
        this.score = score;
    }

    public String getComment()
    {
        return comment;
    }

    public void setComment(String comment)
    {
        this.comment = comment;
    }
}
