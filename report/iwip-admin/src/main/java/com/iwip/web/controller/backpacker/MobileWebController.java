package com.iwip.web.controller.backpacker;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * Serve Flutter mobile web from backend port (same port HP can reach).
 */
@Controller
public class MobileWebController
{
    @GetMapping({ "/app", "/app/" })
    public String mobileApp()
    {
        return "forward:/app/index.html";
    }
}
