<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch">
      <el-form-item :label="t('common.title')" prop="title">
        <el-input v-model="queryParams.title" :placeholder="t('report.searchTitle')" clearable style="width: 200px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item :label="t('common.type')" prop="reportType">
        <el-select v-model="queryParams.reportType" :placeholder="t('report.searchType')" clearable style="width: 160px">
          <el-option v-for="dict in biz_report_type" :key="dict.value" :label="dict.label" :value="dict.value" />
        </el-select>
      </el-form-item>
      <el-form-item :label="t('common.status')" prop="status">
        <el-select v-model="queryParams.status" :placeholder="t('common.status')" clearable style="width: 160px">
          <el-option v-for="dict in biz_report_status" :key="dict.value" :label="dict.label" :value="dict.value" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">{{ t('common.search') }}</el-button>
        <el-button icon="Refresh" @click="resetQuery">{{ t('common.reset') }}</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="Plus" @click="handleAdd" v-hasPermi="['report:report:add']">{{ t('common.add') }}</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" plain icon="Edit" :disabled="single" @click="handleUpdate" v-hasPermi="['report:report:edit']">{{ t('common.edit') }}</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="Delete" :disabled="multiple" @click="handleDelete" v-hasPermi="['report:report:remove']">{{ t('common.delete') }}</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="warning" plain icon="Download" @click="handleExport" v-hasPermi="['report:report:export']">{{ t('common.export') }}</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList" />
    </el-row>

    <el-table v-loading="loading" :data="reportList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column :label="t('report.reportNo')" prop="reportNo" width="160" show-overflow-tooltip />
      <el-table-column :label="t('common.title')" prop="title" min-width="200" show-overflow-tooltip />
      <el-table-column :label="t('common.type')" align="center" width="110">
        <template #default="scope">
          <dict-tag :options="biz_report_type" :value="scope.row.reportType" />
        </template>
      </el-table-column>
      <el-table-column :label="t('common.status')" align="center" width="110">
        <template #default="scope">
          <dict-tag :options="biz_report_status" :value="scope.row.status" />
        </template>
      </el-table-column>
      <el-table-column :label="t('report.reporter')" prop="nickName" width="100" align="center" />
      <el-table-column :label="t('report.department')" prop="deptName" width="120" show-overflow-tooltip />
      <el-table-column :label="t('common.time')" align="center" width="160">
        <template #default="scope">
          <span>{{ parseTime(scope.row.createTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column :label="t('common.action')" align="center" width="280" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button
            v-if="canSubmit(scope.row)"
            link
            type="warning"
            icon="Promotion"
            @click="handleSubmit(scope.row)"
            v-hasPermi="['report:report:edit']"
          >{{ t('report.submit') }}</el-button>
          <el-button
            v-if="canReview(scope.row)"
            link
            type="success"
            icon="CircleCheck"
            @click="handleApprove(scope.row)"
            v-hasRole="['admin']"
          >{{ t('report.approve') }}</el-button>
          <el-button
            v-if="canReview(scope.row)"
            link
            type="danger"
            icon="CircleClose"
            @click="handleReject(scope.row)"
            v-hasRole="['admin']"
          >{{ t('report.reject') }}</el-button>
          <el-button
            v-if="canEdit(scope.row)"
            link
            type="primary"
            icon="Edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['report:report:edit']"
          >{{ t('common.edit') }}</el-button>
          <el-button
            v-if="canDelete(scope.row)"
            link
            type="primary"
            icon="Delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['report:report:remove']"
          >{{ t('common.delete') }}</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize" @pagination="getList" />

    <el-dialog :title="title" v-model="open" width="640px" append-to-body>
      <el-form ref="reportRef" :model="form" :rules="rules" label-width="110px">
        <el-form-item :label="t('common.title')" prop="title">
          <el-input v-model="form.title" :placeholder="t('report.searchTitle')" />
        </el-form-item>
        <el-form-item :label="t('common.type')" prop="reportType">
          <el-select v-model="form.reportType" :placeholder="t('report.selectType')" style="width: 100%">
            <el-option v-for="dict in biz_report_type" :key="dict.value" :label="dict.label" :value="dict.value" />
          </el-select>
        </el-form-item>
        <el-form-item v-if="form.reportId" :label="t('common.status')">
          <dict-tag :options="biz_report_status" :value="form.status" />
        </el-form-item>
        <el-form-item :label="t('report.content')" prop="content">
          <el-input v-model="form.content" type="textarea" :rows="5" :placeholder="t('report.contentPlaceholder')" />
        </el-form-item>
        <el-form-item :label="t('common.remark')" prop="remark">
          <el-input v-model="form.remark" type="textarea" :placeholder="t('report.remarkPlaceholder')" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button type="primary" @click="submitForm">{{ t('common.save') }}</el-button>
        <el-button @click="cancel">{{ t('common.cancel') }}</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="ReportList">
import { useI18n } from 'vue-i18n'
import auth from '@/plugins/auth'
import { listReport, getReport, addReport, updateReport, delReport } from '@/api/report/report'

const { t } = useI18n()
const { proxy } = getCurrentInstance()
const { biz_report_type, biz_report_status } = useDict('biz_report_type', 'biz_report_status')

const reportList = ref([])
const open = ref(false)
const loading = ref(true)
const showSearch = ref(true)
const ids = ref([])
const single = ref(true)
const multiple = ref(true)
const total = ref(0)
const title = ref('')

const data = reactive({
  form: {},
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    title: undefined,
    reportType: undefined,
    status: undefined
  },
  rules: {
    title: [{ required: true, message: t('report.titleRequired'), trigger: 'blur' }],
    reportType: [{ required: true, message: t('report.typeRequired'), trigger: 'change' }]
  }
})

const { queryParams, form, rules } = toRefs(data)

function isAdmin() {
  return auth.hasRole('admin')
}

function canSubmit(row) {
  return row.status === '0' || row.status === '3'
}

function canReview(row) {
  return row.status === '1' && isAdmin()
}

function canEdit(row) {
  if (row.status === '2') {
    return false
  }
  if (row.status === '1') {
    return isAdmin()
  }
  return true
}

function canDelete(row) {
  return row.status === '0' || row.status === '3' || isAdmin()
}

function getList() {
  loading.value = true
  listReport(queryParams.value).then(response => {
    reportList.value = response.rows
    total.value = response.total
    loading.value = false
  })
}

function cancel() {
  open.value = false
  reset()
}

function reset() {
  form.value = {
    reportId: undefined,
    title: undefined,
    reportType: '1',
    status: '0',
    content: undefined,
    remark: undefined
  }
  proxy.resetForm('reportRef')
}

function handleQuery() {
  queryParams.value.pageNum = 1
  getList()
}

function resetQuery() {
  proxy.resetForm('queryRef')
  handleQuery()
}

function handleSelectionChange(selection) {
  ids.value = selection.map(item => item.reportId)
  single.value = selection.length !== 1
  multiple.value = !selection.length
}

function handleAdd() {
  reset()
  open.value = true
  title.value = t('report.addTitle')
}

function handleUpdate(row) {
  const target = row.reportId ? row : reportList.value.find(item => item.reportId === ids.value[0])
  if (!target || !canEdit(target)) {
    proxy.$modal.msgWarning(t('report.lockedHint'))
    return
  }
  reset()
  const reportId = target.reportId || ids.value
  getReport(reportId).then(response => {
    form.value = response.data
    open.value = true
    title.value = t('report.editTitle')
  })
}

function submitForm() {
  proxy.$refs.reportRef.validate(valid => {
    if (!valid) return
    const payload = { ...form.value }
    if (!payload.reportId) {
      payload.status = '0'
    }
    const action = payload.reportId ? updateReport(payload) : addReport(payload)
    action.then(() => {
      proxy.$modal.msgSuccess(t('common.saveSuccess'))
      open.value = false
      getList()
    })
  })
}

function changeStatus(row, status, confirmKey, successKey) {
  proxy.$modal.confirm(t(confirmKey)).then(() => {
    return updateReport({ reportId: row.reportId, status })
  }).then(() => {
    proxy.$modal.msgSuccess(t(successKey))
    getList()
  }).catch(() => {})
}

function handleSubmit(row) {
  changeStatus(row, '1', 'report.confirmSubmit', 'report.submitSuccess')
}

function handleApprove(row) {
  changeStatus(row, '2', 'report.confirmApprove', 'report.approveSuccess')
}

function handleReject(row) {
  changeStatus(row, '3', 'report.confirmReject', 'report.rejectSuccess')
}

function handleDelete(row) {
  const target = row.reportId ? row : reportList.value.find(item => item.reportId === ids.value[0])
  if (target && !canDelete(target)) {
    proxy.$modal.msgWarning(t('report.lockedHint'))
    return
  }
  const reportIds = row.reportId || ids.value
  proxy.$modal.confirm(t('report.confirmDelete')).then(() => {
    return delReport(reportIds)
  }).then(() => {
    getList()
    proxy.$modal.msgSuccess(t('common.deleteSuccess'))
  }).catch(() => {})
}

function handleExport() {
  proxy.download('report/report/export', {
    ...queryParams.value
  }, `laporan_${new Date().getTime()}.xlsx`)
}

getList()
</script>
