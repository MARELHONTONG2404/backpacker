package com.iwip.system.task;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import com.iwip.system.service.IBizOrderService;

/**
 * Tugas terjadwal: otomatis expire pesanan PUBLISHED yang sudah terlalu lama.
 */
@Component
public class BizOrderExpireTask
{
    private static final Logger log = LoggerFactory.getLogger(BizOrderExpireTask.class);

    @Autowired
    private IBizOrderService bizOrderService;

    @Scheduled(cron = "0 0 2 * * ?")
    public void expireStalePublishedOrders()
    {
        int expired = bizOrderService.expireStalePublishedOrders();
        if (expired > 0)
        {
            log.info("Backpacker: {} pesanan PUBLISHED di-expire dengan refund koin", expired);
        }
    }
}
