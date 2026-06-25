<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch">
      <el-form-item :label="t('system.user.userName')" prop="userName">
        <el-input v-model="queryParams.userName" clearable style="width: 150px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item :label="t('backpacker.txType')" prop="txType">
        <el-select v-model="queryParams.txType" clearable style="width: 180px">
          <el-option v-for="dict in biz_coin_tx_type" :key="dict.value" :label="dict.label" :value="dict.value" />
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

    <el-table v-loading="loading" :data="transactionList">
      <el-table-column label="ID" prop="transactionId" width="80" align="center" />
      <el-table-column :label="t('system.user.userName')" prop="userName" width="120" />
      <el-table-column :label="t('system.user.nickName')" prop="nickName" width="130" />
      <el-table-column :label="t('backpacker.txType')" align="center" width="150">
        <template #default="scope">
          <dict-tag :options="biz_coin_tx_type" :value="scope.row.txType" />
        </template>
      </el-table-column>
      <el-table-column :label="t('backpacker.amount')" prop="amount" width="100" align="center">
        <template #default="scope">
          <span :class="scope.row.amount >= 0 ? 'text-success' : 'text-danger'">
            {{ scope.row.amount >= 0 ? '+' : '' }}{{ scope.row.amount }}
          </span>
        </template>
      </el-table-column>
      <el-table-column :label="t('backpacker.balanceAfter')" prop="balanceAfter" width="110" align="center" />
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

<script setup name="BackpackerCoinList">
import { useI18n } from 'vue-i18n'
import { listCoinTransaction } from '@/api/backpacker/coin'

const { t } = useI18n()
const { proxy } = getCurrentInstance()
const { biz_coin_tx_type } = useDict('biz_coin_tx_type')

const transactionList = ref([])
const loading = ref(true)
const showSearch = ref(true)
const total = ref(0)

const queryParams = ref({
  pageNum: 1,
  pageSize: 10,
  userName: undefined,
  txType: undefined
})

function getList() {
  loading.value = true
  listCoinTransaction(queryParams.value).then(response => {
    transactionList.value = response.rows
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
