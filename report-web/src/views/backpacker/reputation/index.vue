<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch">
      <el-form-item :label="t('system.user.userName')" prop="userName">
        <el-input v-model="queryParams.userName" clearable style="width: 150px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item :label="t('backpacker.reputationReason')" prop="reason">
        <el-select v-model="queryParams.reason" clearable style="width: 180px">
          <el-option v-for="dict in biz_reputation_reason" :key="dict.value" :label="dict.label" :value="dict.value" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">{{ t('common.search') }}</el-button>
        <el-button icon="Refresh" @click="resetQuery">{{ t('common.reset') }}</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList" />
    </el-row>

    <el-table v-loading="loading" :data="logList">
      <el-table-column label="ID" prop="logId" width="80" align="center" />
      <el-table-column :label="t('system.user.userName')" prop="userName" width="120" />
      <el-table-column :label="t('system.user.nickName')" prop="nickName" width="130" />
      <el-table-column :label="t('backpacker.reputationReason')" align="center" width="160">
        <template #default="scope">
          <dict-tag :options="biz_reputation_reason" :value="scope.row.reason" />
        </template>
      </el-table-column>
      <el-table-column :label="t('backpacker.delta')" prop="delta" width="90" align="center">
        <template #default="scope">
          <span :class="scope.row.delta >= 0 ? 'text-success' : 'text-danger'">
            {{ scope.row.delta >= 0 ? '+' : '' }}{{ scope.row.delta }}
          </span>
        </template>
      </el-table-column>
      <el-table-column :label="t('backpacker.scoreAfter')" prop="scoreAfter" width="110" align="center" />
      <el-table-column :label="t('backpacker.refId')" prop="refId" width="90" align="center" />
      <el-table-column :label="t('common.remark')" prop="remark" min-width="160" show-overflow-tooltip />
      <el-table-column :label="t('common.time')" align="center" width="160">
        <template #default="scope">
          <span>{{ parseTime(scope.row.createTime) }}</span>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize" @pagination="getList" />
  </div>
</template>

<script setup name="BackpackerReputationList">
import { useI18n } from 'vue-i18n'
import { listReputationLog } from '@/api/backpacker/reputation'

const { t } = useI18n()
const { proxy } = getCurrentInstance()
const { biz_reputation_reason } = useDict('biz_reputation_reason')

const logList = ref([])
const loading = ref(true)
const showSearch = ref(true)
const total = ref(0)

const queryParams = ref({
  pageNum: 1,
  pageSize: 10,
  userName: undefined,
  reason: undefined
})

function getList() {
  loading.value = true
  listReputationLog(queryParams.value).then(response => {
    logList.value = response.rows
    total.value = response.total
    loading.value = false
  })
}

function handleQuery() {
  queryParams.value.pageNum = 1
  getList()
}

function resetQuery() {
  proxy.resetForm('queryRef')
  handleQuery()
}

getList()
</script>

<style scoped>
.text-success { color: #67c23a; font-weight: 600; }
.text-danger { color: #f56c6c; font-weight: 600; }
</style>
