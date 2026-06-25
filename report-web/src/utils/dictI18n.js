import i18n from '@/locales'
import zhCnMessages from '@/locales/zh-cn'

export function translateDictLabel(dictType, dictValue, fallback = '') {
  if (i18n.global.locale.value !== 'zh-cn') {
    return fallback
  }
  return zhCnMessages.dict?.[dictType]?.[dictValue] ?? fallback
}

export function localizeDictOptions(dictType, options = []) {
  if (i18n.global.locale.value !== 'zh-cn') {
    return options
  }
  return options.map(option => ({
    ...option,
    label: translateDictLabel(dictType, option.value, option.label)
  }))
}
