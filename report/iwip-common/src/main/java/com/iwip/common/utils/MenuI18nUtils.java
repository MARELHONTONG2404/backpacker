package com.iwip.common.utils;

import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import com.iwip.common.utils.spring.SpringUtils;

/**
 * Resolves localized menu titles from message bundles.
 */
public final class MenuI18nUtils
{
    private MenuI18nUtils()
    {
    }

    public static String resolveTitle(String titleKey, String defaultTitle)
    {
        if (StringUtils.isEmpty(titleKey))
        {
            return defaultTitle;
        }
        try
        {
            MessageSource messageSource = SpringUtils.getBean(MessageSource.class);
            return messageSource.getMessage(titleKey, null, defaultTitle, LocaleContextHolder.getLocale());
        }
        catch (Exception ex)
        {
            return defaultTitle;
        }
    }
}
