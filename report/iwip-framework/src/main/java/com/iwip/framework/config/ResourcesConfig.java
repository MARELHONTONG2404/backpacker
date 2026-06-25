package com.iwip.framework.config;

import java.util.concurrent.TimeUnit;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.CacheControl;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import com.iwip.common.config.Config;
import com.iwip.common.constant.Constants;
import com.iwip.common.utils.StringUtils;
import com.iwip.framework.interceptor.RepeatSubmitInterceptor;

/**
 * 通用配置
 *
 * @author iwip
 */
@Configuration
public class ResourcesConfig implements WebMvcConfigurer
{
    @Autowired
    private RepeatSubmitInterceptor repeatSubmitInterceptor;

    @Value("${cors.allowed-origin-patterns:*}")
    private String allowedOriginPatterns;

    /** Flutter web build for HP access via backend port (e.g. /app/ on :8080) */
    @Value("${backpacker.mobile-web-path:}")
    private String mobileWebPath;

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry)
    {
        /** 本地文件上传路径 */
        registry.addResourceHandler(Constants.RESOURCE_PREFIX + "/**")
                .addResourceLocations("file:" + Config.getProfile() + "/");

        if (StringUtils.isNotEmpty(mobileWebPath))
        {
            String location = mobileWebPath.endsWith("/") ? mobileWebPath : mobileWebPath + "/";
            registry.addResourceHandler("/app/**")
                    .addResourceLocations("file:" + location)
                    .setCacheControl(CacheControl.noCache());
        }
    }

    /**
     * 自定义拦截规则
     */
    @Override
    public void addInterceptors(InterceptorRegistry registry)
    {
        registry.addInterceptor(repeatSubmitInterceptor).addPathPatterns("/**");
    }

    /**
     * 跨域配置
     */
    @Bean
    public CorsFilter corsFilter()
    {
        CorsConfiguration config = new CorsConfiguration();
        for (String origin : allowedOriginPatterns.split(","))
        {
            String trimmed = origin.trim();
            if (!trimmed.isEmpty())
            {
                config.addAllowedOriginPattern(trimmed);
            }
        }
        // 设置访问源请求头
        config.addAllowedHeader("*");
        // 设置访问源请求方法
        config.addAllowedMethod("*");
        // 有效期 1800秒
        config.setMaxAge(1800L);
        // 添加映射路径，拦截一切请求
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", config);
        // 返回新的CorsFilter
        return new CorsFilter(source);
    }
}
