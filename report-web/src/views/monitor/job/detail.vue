<template>
  <el-dialog :title="type === 'log' ? t('monitor.job.logDetailTitle') : t('monitor.job.jobDetailTitle')" v-model="dialogVisible" width="780px" append-to-body>
    <div class="detail-wrap">
      <template v-if="type === 'log'">
        <div class="detail-card">
          <div class="detail-card-title">
            <el-icon><InfoFilled /></el-icon> {{ t('monitor.operDetail.basicInfo') }}
          </div>
          <el-row class="detail-row">
            <el-col :span="12">
              <div class="detail-item"><span class="detail-label">{{ t('monitor.job.logId') }}</span><span class="detail-value">{{ form.jobLogId }}</span></div>
            </el-col>
            <el-col :span="12">
              <div class="detail-item">
                <span class="detail-label">{{ t('monitor.job.execStatus') }}</span>
                <el-tag v-if="form.status == 0" type="success" size="small">{{ t('monitor.operDetail.normal') }}</el-tag>
                <el-tag v-else type="danger" size="small">{{ t('monitor.operDetail.fail') }}</el-tag>
              </div>
            </el-col>
          </el-row>
          <el-row class="detail-row">
            <el-col :span="12">
              <div class="detail-item"><span class="detail-label">{{ t('monitor.job.startTime') }}</span><span class="detail-value">{{ form.startTime }}</span></div>
            </el-col>
            <el-col :span="12">
              <div class="detail-item"><span class="detail-label">{{ t('monitor.job.endTime') }}</span><span class="detail-value">{{ form.endTime }}</span></div>
            </el-col>
          </el-row>
          <el-row class="detail-row">
            <el-col :span="12">
              <div class="detail-item"><span class="detail-label">{{ t('monitor.job.recordTime') }}</span><span class="detail-value">{{ form.createTime }}</span></div>
            </el-col>
            <el-col :span="12" v-if="form.status == 0 && form.startTime && form.endTime">
              <div class="detail-item"><span class="detail-label">{{ t('monitor.job.execDuration') }}</span><span class="detail-value">{{ t('monitor.costTimeMs', { ms: costTime }) }}</span></div>
            </el-col>
          </el-row>
        </div>
        <div class="detail-card">
          <div class="detail-card-title">
            <el-icon><Clock /></el-icon> {{ t('monitor.job.taskInfo') }}
          </div>
          <el-row class="detail-row">
            <el-col :span="12">
              <div class="detail-item"><span class="detail-label">{{ t('monitor.job.jobName') }}</span><span class="detail-value">{{ form.jobName }}</span></div>
            </el-col>
            <el-col :span="12">
              <div class="detail-item">
                <span class="detail-label">{{ t('monitor.job.jobGroupLabel') }}</span>
                <dict-tag :options="sys_job_group" :value="form.jobGroup" />
              </div>
            </el-col>
          </el-row>
          <el-row class="detail-row">
            <el-col :span="24">
              <div class="detail-item"><span class="detail-label">{{ t('monitor.job.logMessage') }}</span><span class="detail-value">{{ form.jobMessage }}</span></div>
            </el-col>
          </el-row>
        </div>
        <div class="detail-card">
          <div class="detail-card-title">
            <el-icon><Operation /></el-icon> {{ t('monitor.job.invokeTargetSection') }}
          </div>
          <div class="code-body">
            <div class="code-wrap"><pre class="code-pre">{{ form.invokeTarget || t('monitor.job.emptyValue') }}</pre></div>
          </div>
        </div>
        <div class="detail-card" v-if="form.status == 1">
          <div class="detail-card-title error-title">
            <el-icon><Warning /></el-icon> {{ t('monitor.job.errorInfo') }}
          </div>
          <div class="error-body"><div class="error-msg">{{ form.exceptionInfo }}</div></div>
        </div>
      </template>

      <template v-else>
        <div class="detail-card">
          <div class="detail-card-title">
            <el-icon><Setting /></el-icon> {{ t('monitor.job.taskConfig') }}
          </div>
          <el-row class="detail-row">
            <el-col :span="12">
              <div class="detail-item"><span class="detail-label">{{ t('monitor.job.jobId') }}</span><span class="detail-value">{{ form.jobId }}</span></div>
            </el-col>
            <el-col :span="12">
              <div class="detail-item"><span class="detail-label">{{ t('monitor.job.jobName') }}</span><span class="detail-value">{{ form.jobName }}</span></div>
            </el-col>
          </el-row>
          <el-row class="detail-row">
            <el-col :span="12">
              <div class="detail-item">
                <span class="detail-label">{{ t('monitor.job.jobGroupLabel') }}</span>
                <dict-tag :options="sys_job_group" :value="form.jobGroup" />
              </div>
            </el-col>
            <el-col :span="12">
              <div class="detail-item">
                <span class="detail-label">{{ t('monitor.job.execStatus') }}</span>
                <el-tag v-if="form.status == 0" type="success" size="small">{{ t('monitor.operDetail.normal') }}</el-tag>
                <el-tag v-else type="info" size="small">{{ t('monitor.job.paused') }}</el-tag>
              </div>
            </el-col>
          </el-row>
        </div>
        <div class="detail-card">
          <div class="detail-card-title">
            <el-icon><Calendar /></el-icon> {{ t('monitor.job.scheduleInfo') }}
          </div>
          <el-row class="detail-row">
            <el-col :span="12">
              <div class="detail-item"><span class="detail-label">{{ t('monitor.job.cronExpression') }}</span><span class="detail-value mono">{{ form.cronExpression }}</span></div>
            </el-col>
            <el-col :span="12">
              <div class="detail-item"><span class="detail-label">{{ t('monitor.job.nextRun') }}</span><span class="detail-value">{{ parseTime(form.nextValidTime) }}</span></div>
            </el-col>
          </el-row>
          <el-row class="detail-row">
            <el-col :span="12">
              <div class="detail-item">
                <span class="detail-label">{{ t('monitor.job.execPolicy') }}</span>
                <el-tag v-if="form.misfirePolicy == 0" type="info" size="small">{{ t('monitor.job.defaultPolicy') }}</el-tag>
                <el-tag v-else-if="form.misfirePolicy == 1" type="warning" size="small">{{ t('monitor.job.runImmediate') }}</el-tag>
                <el-tag v-else-if="form.misfirePolicy == 2" type="primary" size="small">{{ t('monitor.job.misfireOnce') }}</el-tag>
                <el-tag v-else-if="form.misfirePolicy == 3" type="danger" size="small">{{ t('monitor.job.abandon') }}</el-tag>
              </div>
            </el-col>
            <el-col :span="12">
              <div class="detail-item">
                <span class="detail-label">{{ t('monitor.job.concurrentExec') }}</span>
                <el-tag v-if="form.concurrent == 0" type="success" size="small">{{ t('monitor.job.allow') }}</el-tag>
                <el-tag v-else type="danger" size="small">{{ t('monitor.job.forbid') }}</el-tag>
              </div>
            </el-col>
          </el-row>
        </div>
        <div class="detail-card">
          <div class="detail-card-title">
            <el-icon><Operation /></el-icon> {{ t('monitor.job.execMethod') }}
          </div>
          <div class="code-body">
            <div class="code-wrap"><pre class="code-pre">{{ form.invokeTarget || t('monitor.job.emptyValue') }}</pre></div>
          </div>
        </div>
        <div class="detail-card">
          <div class="detail-card-title">
            <el-icon><Document /></el-icon> {{ t('monitor.job.metaInfo') }}
          </div>
          <el-row class="detail-row">
            <el-col :span="12">
              <div class="detail-item"><span class="detail-label">{{ t('monitor.job.creator') }}</span><span class="detail-value">{{ form.createBy || '-' }}</span></div>
            </el-col>
            <el-col :span="12">
              <div class="detail-item"><span class="detail-label">{{ t('system.createTime') }}</span><span class="detail-value">{{ form.createTime }}</span></div>
            </el-col>
          </el-row>
          <el-row class="detail-row">
            <el-col :span="12">
              <div class="detail-item"><span class="detail-label">{{ t('monitor.job.updater') }}</span><span class="detail-value">{{ form.updateBy || '-' }}</span></div>
            </el-col>
            <el-col :span="12">
              <div class="detail-item"><span class="detail-label">{{ t('system.profile.updateTime') }}</span><span class="detail-value">{{ form.updateTime || '-' }}</span></div>
            </el-col>
          </el-row>
          <el-row class="detail-row" v-if="form.remark">
            <el-col :span="24">
              <div class="detail-item"><span class="detail-label">{{ t('common.remark') }}</span><span class="detail-value">{{ form.remark }}</span></div>
            </el-col>
          </el-row>
        </div>
      </template>
    </div>
    <template #footer>
      <div class="dialog-footer">
        <el-button @click="dialogVisible = false">{{ t('common.close') }}</el-button>
      </div>
    </template>
  </el-dialog>
</template>

<script setup name="JobDetail">
import { useI18n } from 'vue-i18n'

const { t } = useI18n()

const props = defineProps({
  visible: { type: Boolean, default: false },
  row: { type: Object, default: () => ({}) },
  type: { type: String, default: 'job' }
})

const emit = defineEmits(['update:visible'])

const dialogVisible = computed({
  get: () => props.visible,
  set: (val) => emit('update:visible', val)
})

const { sys_job_group } = useDict('sys_job_group')

const form = computed(() => props.row || {})

const costTime = computed(() => {
  if (!form.value.startTime || !form.value.endTime) return 0
  return new Date(form.value.endTime).getTime() - new Date(form.value.startTime).getTime()
})
</script>

<style scoped>
.detail-label {
  width: 80px;
}
</style>
