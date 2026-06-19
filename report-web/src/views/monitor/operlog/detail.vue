<template>
  <el-dialog :title="t('monitor.operDetail.title')" v-model="dialogVisible" width="780px" append-to-body @close="$emit('update:visible', false)">
    <div class="detail-wrap">
      <div class="detail-card">
        <div class="detail-card-title"><el-icon><InfoFilled /></el-icon> {{ t('monitor.operDetail.basicInfo') }}</div>
        <el-row class="detail-row">
          <el-col :span="12">
            <div class="detail-item"><span class="detail-label">{{ t('monitor.operDetail.operModule') }}</span><span class="detail-value">{{ form.title }}</span></div>
          </el-col>
          <el-col :span="12">
            <div class="detail-item"><span class="detail-label">{{ t('monitor.operDetail.businessType') }}</span><span class="detail-value">{{ typeLabel }}</span></div>
          </el-col>
        </el-row>
        <el-row class="detail-row">
          <el-col :span="12">
            <div class="detail-item"><span class="detail-label">{{ t('monitor.operDetail.operTime') }}</span><span class="detail-value">{{ form.operTime }}</span></div>
          </el-col>
          <el-col :span="12">
            <div class="detail-item">
              <span class="detail-label">{{ t('monitor.operDetail.execStatus') }}</span>
              <el-tag v-if="form.status === 0" type="success" size="small">{{ t('monitor.operDetail.normal') }}</el-tag>
              <el-tag v-else type="danger" size="small">{{ t('monitor.operDetail.abnormal') }}</el-tag>
            </div>
          </el-col>
        </el-row>
      </div>

      <div class="detail-card">
        <div class="detail-card-title"><el-icon><User /></el-icon> {{ t('monitor.operDetail.operPerson') }}</div>
        <el-row class="detail-row">
          <el-col :span="12">
            <div class="detail-item"><span class="detail-label">{{ t('monitor.operDetail.operName') }}</span><span class="detail-value">{{ form.operName }}</span></div>
          </el-col>
          <el-col :span="12" v-if="form.deptName">
            <div class="detail-item"><span class="detail-label">{{ t('monitor.operDetail.belongDept') }}</span><span class="detail-value">{{ form.deptName }}</span></div>
          </el-col>
        </el-row>
        <el-row class="detail-row">
          <el-col :span="24">
            <div class="detail-item">
              <span class="detail-label">{{ t('monitor.operDetail.operAddress') }}</span>
              <span class="detail-value">{{ form.operIp }}&nbsp;&nbsp;<span class="detail-location">{{ form.operLocation }}</span></span>
            </div>
          </el-col>
        </el-row>
      </div>

      <div class="detail-card">
        <div class="detail-card-title"><el-icon><Sort /></el-icon> {{ t('monitor.operDetail.requestInfo') }}</div>
        <el-row class="detail-row">
          <el-col :span="24">
            <div class="detail-item">
              <span class="detail-label">{{ t('monitor.operDetail.requestAddr') }}</span>
              <span class="detail-value">
                <span :class="'method-tag method-' + form.requestMethod">{{ form.requestMethod }}</span>
                {{ form.operUrl }}
              </span>
            </div>
          </el-col>
        </el-row>
        <el-row class="detail-row">
          <el-col :span="24">
            <div class="detail-item"><span class="detail-label">{{ t('monitor.operDetail.operMethod') }}</span><span class="detail-value mono">{{ form.method }}</span></div>
          </el-col>
        </el-row>
        <el-row class="detail-row">
          <el-col :span="12">
            <div class="detail-item"><span class="detail-label">{{ t('monitor.operDetail.costTimeLabel') }}</span><span class="detail-value">{{ t('monitor.costTimeMs', { ms: form.costTime }) }}</span></div>
          </el-col>
        </el-row>
      </div>

      <div class="detail-card">
        <div class="detail-card-title"><el-icon><Upload /></el-icon> {{ t('monitor.operDetail.requestParam') }}</div>
        <div class="code-body">
          <div class="code-wrap">
            <div class="code-action">
              <el-button size="small" :icon="CopyDocument" @click="copyText(form.operParam)">{{ t('common.copy') }}</el-button>
            </div>
            <pre class="code-pre">{{ formatJson(form.operParam) }}</pre>
          </div>
        </div>
      </div>

      <div class="detail-card">
        <div class="detail-card-title"><el-icon><Download /></el-icon> {{ t('monitor.operDetail.responseResult') }}</div>
        <div class="code-body">
          <div class="code-wrap">
            <div class="code-action">
              <el-button size="small" :icon="CopyDocument" @click="copyText(form.jsonResult)">{{ t('common.copy') }}</el-button>
            </div>
            <pre class="code-pre">{{ formatJson(form.jsonResult) }}</pre>
          </div>
        </div>
      </div>

      <div class="detail-card" v-if="form.status !== 0">
        <div class="detail-card-title error-title"><el-icon><Warning /></el-icon> {{ t('monitor.operDetail.errorInfo') }}</div>
        <div class="error-body">
          <div class="error-msg">{{ form.errorMsg }}</div>
        </div>
      </div>

    </div>
  </el-dialog>
</template>

<script setup>
import { useI18n } from 'vue-i18n'

const { t } = useI18n()

const props = defineProps({
  visible: { type: Boolean, default: false },
  row: { type: Object, default: () => ({}) }
})

const emit = defineEmits(['update:visible'])

const dialogVisible = computed({
  get: () => props.visible,
  set: (val) => emit('update:visible', val)
})

const { sys_oper_type } = useDict('sys_oper_type')

const form = computed(() => props.row || {})
const typeLabel = computed(() => selectDictLabel(sys_oper_type.value, form.value.businessType) || '-')

function formatJson(str) {
  if (!str) return t('common.noContent')
  try { return JSON.stringify(JSON.parse(str), null, 2) } catch { return str }
}

function copyText(str) {
  const text = formatJson(str)
  if (navigator.clipboard) {
    navigator.clipboard.writeText(text).then(() => ElMessage({ message: t('common.copied'), type: 'success', duration: 1500 }))
  } else {
    const ta = document.createElement('textarea')
    ta.value = text
    document.body.appendChild(ta)
    ta.select()
    document.execCommand('copy')
    document.body.removeChild(ta)
    ElMessage({ message: t('common.copied'), type: 'success', duration: 1500 })
  }
}
</script>
