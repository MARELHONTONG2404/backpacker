<template>
  <el-dialog :title="dialogTitle" v-model="visible" :width="width" append-to-body @close="handleClose">
    <el-upload ref="uploadRef" :limit="1" accept=".xlsx, .xls" :headers="headers" :action="uploadUrl" :disabled="isUploading" :on-progress="handleProgress" :on-change="handleFileChange" :on-remove="handleFileRemove" :on-success="handleSuccess" :auto-upload="false" drag>
      <el-icon class="el-icon--upload"><upload-filled /></el-icon>
      <div class="el-upload__text">{{ t('components.excelImport.dragText') }}<em>{{ t('components.excelImport.clickUpload') }}</em></div>
      <template #tip>
        <div class="el-upload__tip text-center">
          <div class="el-upload__tip">
            <el-checkbox v-model="updateSupport"> {{ updateSupportLabel || t('components.excelImport.updateSupport') }} </el-checkbox>
          </div>
          <span>{{ t('components.excelImport.formatTip') }}</span>
          <el-link v-if="templateUrl" type="primary" underline="never" style="font-size: 12px; vertical-align: baseline" @click="handleDownloadTemplate">{{ t('components.excelImport.downloadTemplate') }}</el-link>
        </div>
      </template>
    </el-upload>
    <template #footer>
      <div class="dialog-footer">
        <el-button type="primary" @click="handleSubmit">{{ t('components.excelImport.confirm') }}</el-button>
        <el-button @click="visible = false">{{ t('components.excelImport.cancel') }}</el-button>
      </div>
    </template>
  </el-dialog>
</template>

<script setup>
import { useI18n } from 'vue-i18n'
import { getToken } from '@/utils/auth'

const { t } = useI18n()
const { proxy } = getCurrentInstance()

const props = defineProps({
  title: {
    type: String,
    default: ''
  },
  width: {
    type: String,
    default: '400px'
  },
  action: {
    type: String,
    required: true
  },
  templateAction: {
    type: String,
    default: ''
  },
  templateFileName: {
    type: String,
    default: 'template'
  },
  updateSupportLabel: {
    type: String,
    default: ''
  }
})

const emit = defineEmits(['success'])

const dialogTitle = computed(() => props.title || t('components.excelImport.title'))

const uploadRef = ref(null)
const visible = ref(false)
const selectedFile = ref(null)
const isUploading = ref(false)
const updateSupport = ref(false)
const headers = { access_token: 'Bearer ' + getToken() }

const uploadUrl = computed(() => {
  return import.meta.env.VITE_APP_BASE_API + props.action + '?updateSupport=' + (updateSupport.value ? 1 : 0)
})

const templateUrl = computed(() => !!props.templateAction)

function open() {
  updateSupport.value = false
  isUploading.value = false
  visible.value = true
  nextTick(() => {
    selectedFile.value = null
    uploadRef.value?.clearFiles()
  })
}

function handleClose() {
  isUploading.value = false
  selectedFile.value = null
  uploadRef.value?.clearFiles()
}

function handleDownloadTemplate() {
  proxy.download(props.templateAction, {}, `${props.templateFileName}_${new Date().getTime()}.xlsx`)
}

function handleProgress() {
  isUploading.value = true
}

const handleFileChange = (file, fileList) => {
  selectedFile.value = file
}

const handleFileRemove = (file, fileList) => {
  selectedFile.value = null
}

function handleSuccess(response) {
  visible.value = false
  isUploading.value = false
  selectedFile.value = null
  uploadRef.value?.clearFiles()
  proxy.$alert("<div style='overflow:auto;overflow-x:hidden;max-height:70vh;padding:10px 20px 0;'>" + response.msg + '</div>', t('components.excelImport.resultTitle'), { dangerouslyUseHTMLString: true })
  emit('success')
}

function handleSubmit() {
  const file = selectedFile.value
  if (!file || file.length === 0 || !file.name.toLowerCase().endsWith('.xls') && !file.name.toLowerCase().endsWith('.xlsx')) {
    proxy.$modal.msgError(t('components.excelImport.fileRequired'))
    return
  }
  uploadRef.value.submit()
}

defineExpose({ open })
</script>
