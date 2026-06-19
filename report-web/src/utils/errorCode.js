import i18n from '@/locales'

export default {
  get(code) {
    const key = `error.${code}`
    const msg = i18n.global.t(key)
    return msg !== key ? msg : i18n.global.t('error.default')
  }
}
