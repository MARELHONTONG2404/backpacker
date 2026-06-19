import axios from 'axios'
import { ElNotification , ElMessageBox, ElMessage, ElLoading } from 'element-plus'
import { getToken } from '@/utils/auth'
import { tansParams, blobValidate } from '@/utils/tool'
import cache from '@/plugins/cache'
import { saveAs } from 'file-saver'
import useUserStore from '@/store/modules/user'
import i18n from '@/locales'

let downloadLoadingInstance
export let isRelogin = { show: false }

axios.defaults.headers['Content-Type'] = 'application/json;charset=utf-8'
const service = axios.create({
  baseURL: import.meta.env.VITE_APP_BASE_API,
  timeout: 10000
})

service.interceptors.request.use(config => {
  const isToken = (config.headers || {}).isToken === false
  const isRepeatSubmit = (config.headers || {}).repeatSubmit === false
  const interval = (config.headers || {}).interval || 1000
  if (getToken() && !isToken) {
    config.headers['access_token'] = 'Bearer ' + getToken()
  }
  const savedLocale = localStorage.getItem('locale') || 'id'
  config.headers['Accept-Language'] = savedLocale === 'zh-cn' ? 'zh-CN' : 'id'
  if (config.method === 'get' && config.params) {
    let url = config.url + '?' + tansParams(config.params)
    url = url.slice(0, -1)
    config.params = {}
    config.url = url
  }
  if (!isRepeatSubmit && (config.method === 'post' || config.method === 'put')) {
    const requestObj = {
      url: config.url,
      data: typeof config.data === 'object' ? JSON.stringify(config.data) : config.data,
      time: new Date().getTime()
    }
    const requestSize = Object.keys(JSON.stringify(requestObj)).length
    const limitSize = 5 * 1024 * 1024
    if (requestSize >= limitSize) {
      console.warn(`[${config.url}]: request payload exceeds 5MB limit`)
      return config
    }
    const sessionObj = cache.session.getJSON('sessionObj')
    if (sessionObj === undefined || sessionObj === null || sessionObj === '') {
      cache.session.setJSON('sessionObj', requestObj)
    } else {
      const s_url = sessionObj.url
      const s_data = sessionObj.data
      const s_time = sessionObj.time
      if (s_data === requestObj.data && requestObj.time - s_time < interval && s_url === requestObj.url) {
        const message = i18n.global.t('common.duplicateSubmit')
        console.warn(`[${s_url}]: ${message}`)
        return Promise.reject(new Error(message))
      } else {
        cache.session.setJSON('sessionObj', requestObj)
      }
    }
  }
  return config
}, error => {
    console.log(error)
    Promise.reject(error)
})

service.interceptors.response.use(res => {
    const code = res.data.code || 200
    const msg = res.data.msg || i18n.global.t(`error.${code}`) || i18n.global.t('error.default')
    if (res.request.responseType ===  'blob' || res.request.responseType ===  'arraybuffer') {
      return res.data
    }
    if (code === 401) {
      if (!isRelogin.show) {
        isRelogin.show = true
        ElMessageBox.confirm(
          i18n.global.t('error.sessionExpired'),
          i18n.global.t('error.reloginTitle'),
          {
            confirmButtonText: i18n.global.t('error.reloginConfirm'),
            cancelButtonText: i18n.global.t('common.cancel'),
            type: 'warning'
          }
        ).then(() => {
          isRelogin.show = false
          useUserStore().logOut().then(() => {
            location.href = '/index'
          })
        }).catch(() => {
          isRelogin.show = false
        })
      }
      return Promise.reject(i18n.global.t('error.sessionExpired'))
    } else if (code === 500) {
      ElMessage({ message: msg, type: 'error' })
      return Promise.reject(new Error(msg))
    } else if (code === 601) {
      ElMessage({ message: msg, type: 'warning' })
      return Promise.reject(new Error(msg))
    } else if (code !== 200) {
      ElNotification.error({ title: msg })
      return Promise.reject('error')
    } else {
      return Promise.resolve(res.data)
    }
  },
  error => {
    console.log('err' + error)
    let { message } = error
    if (message == "Network Error") {
      message = i18n.global.t('error.networkError')
    } else if (message.includes("timeout")) {
      message = i18n.global.t('error.timeout')
    } else if (message.includes("Request failed with status code")) {
      message = i18n.global.t('error.requestFailed') + message.slice(-3)
    }
    ElMessage({ message: message, type: 'error', duration: 5 * 1000 })
    return Promise.reject(error)
  }
)

export function download(url, params, filename, config) {
  downloadLoadingInstance = ElLoading.service({
    text: i18n.global.t('common.downloading'),
    background: "rgba(0, 0, 0, 0.7)"
  })
  return service.post(url, params, {
    transformRequest: [(params) => { return tansParams(params) }],
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    responseType: 'blob',
    ...config
  }).then(async (data) => {
    const isBlob = blobValidate(data)
    if (isBlob) {
      const blob = new Blob([data])
      saveAs(blob, filename)
    } else {
      const resText = await data.text()
      const rspObj = JSON.parse(resText)
      const errMsg = rspObj.msg || i18n.global.t(`error.${rspObj.code}`) || i18n.global.t('error.default')
      ElMessage.error(errMsg)
    }
    downloadLoadingInstance.close()
  }).catch((r) => {
    console.error(r)
    ElMessage.error(i18n.global.t('common.downloadError'))
    downloadLoadingInstance.close()
  })
}

export default service
