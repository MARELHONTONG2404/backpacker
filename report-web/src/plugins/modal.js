import { ElMessage, ElMessageBox, ElNotification, ElLoading } from 'element-plus'
import i18n from '@/locales'

let loadingInstance

function t(key) {
  return i18n.global.t(key)
}

function dialogOptions(type) {
  const options = {
    confirmButtonText: t('components.modal.confirm'),
    cancelButtonText: t('components.modal.cancel')
  }
  if (type) {
    options.type = type
  }
  return options
}

export default {
  msg(content) {
    ElMessage.info(content)
  },
  msgError(content) {
    ElMessage.error(content)
  },
  msgSuccess(content) {
    ElMessage.success(content)
  },
  msgWarning(content) {
    ElMessage.warning(content)
  },
  alert(content) {
    ElMessageBox.alert(content, t('components.modal.title'))
  },
  alertError(content) {
    ElMessageBox.alert(content, t('components.modal.title'), { type: 'error' })
  },
  alertSuccess(content) {
    ElMessageBox.alert(content, t('components.modal.title'), { type: 'success' })
  },
  alertWarning(content) {
    ElMessageBox.alert(content, t('components.modal.title'), { type: 'warning' })
  },
  notify(content) {
    ElNotification.info(content)
  },
  notifyError(content) {
    ElNotification.error(content)
  },
  notifySuccess(content) {
    ElNotification.success(content)
  },
  notifyWarning(content) {
    ElNotification.warning(content)
  },
  confirm(content) {
    return ElMessageBox.confirm(content, t('components.modal.title'), dialogOptions('warning'))
  },
  prompt(content) {
    return ElMessageBox.prompt(content, t('components.modal.title'), dialogOptions('warning'))
  },
  loading(content) {
    loadingInstance = ElLoading.service({
      lock: true,
      text: content,
      background: 'rgba(0, 0, 0, 0.7)'
    })
  },
  closeLoading() {
    loadingInstance.close()
  }
}
