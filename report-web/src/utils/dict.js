import useDictStore from '@/store/modules/dict'
import { getDicts } from '@/api/system/dict/data'
import { localizeDictOptions } from '@/utils/dictI18n'

function mapDictRows(dictType, rows = []) {
  const items = rows.map(row => ({
    label: row.dictLabel,
    value: row.dictValue,
    elTagType: row.listClass,
    elTagClass: row.cssClass
  }))
  return localizeDictOptions(dictType, items)
}

/**
 * 获取字典数据
 */
export function useDict(...args) {
  const res = ref({})
  return (() => {
    args.forEach((dictType) => {
      res.value[dictType] = []
      const dicts = useDictStore().getDict(dictType)
      if (dicts) {
        res.value[dictType] = localizeDictOptions(dictType, dicts)
      } else {
        getDicts(dictType).then(resp => {
          const items = mapDictRows(dictType, resp.data)
          useDictStore().setDict(dictType, resp.data.map(p => ({
            label: p.dictLabel,
            value: p.dictValue,
            elTagType: p.listClass,
            elTagClass: p.cssClass
          })))
          res.value[dictType] = items
        })
      }
    })
    return toRefs(res.value)
  })()
}