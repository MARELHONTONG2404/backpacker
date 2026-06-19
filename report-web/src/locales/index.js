import { createI18n } from 'vue-i18n'
import id from './id'
import zhCn from './zh-cn'

const savedLocale = localStorage.getItem('locale') || 'id'

const i18n = createI18n({
  legacy: false,
  globalInjection: true,
  locale: savedLocale,
  fallbackLocale: 'zh-cn',
  messages: {
    id,
    'zh-cn': zhCn
  }
})

export default i18n
