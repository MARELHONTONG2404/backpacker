<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch">
      <el-form-item :label="t('backpacker.orderNo')" prop="orderNo">
        <el-input v-model="queryParams.orderNo" :placeholder="t('backpacker.searchOrderNo')" clearable style="width: 180px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item :label="t('common.title')" prop="title">
        <el-input v-model="queryParams.title" :placeholder="t('backpacker.searchTitle')" clearable style="width: 180px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item :label="t('backpacker.searchCategory')" prop="category">
        <el-select v-model="queryParams.category" :placeholder="t('backpacker.searchCategory')" clearable style="width: 160px">
          <el-option v-for="dict in biz_order_category" :key="dict.value" :label="dict.label" :value="dict.value" />
        </el-select>
      </el-form-item>
      <el-form-item :label="t('common.status')" prop="status">
        <el-select v-model="queryParams.status" :placeholder="t('common.status')" clearable style="width: 160px">
          <el-option v-for="dict in biz_order_status" :key="dict.value" :label="dict.label" :value="dict.value" />
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

    <el-table v-loading="loading" :data="orderList">
      <el-table-column :label="t('backpacker.orderNo')" prop="orderNo" width="170" show-overflow-tooltip />
      <el-table-column :label="t('common.title')" prop="title" min-width="180" show-overflow-tooltip />
      <el-table-column :label="t('backpacker.searchCategory')" align="center" width="120">
        <template #default="scope">
          <dict-tag :options="biz_order_category" :value="scope.row.category" />
        </template>
      </el-table-column>
      <el-table-column :label="t('common.status')" align="center" width="130">
        <template #default="scope">
          <dict-tag :options="biz_order_status" :value="scope.row.status" />
        </template>
      </el-table-column>
      <el-table-column :label="t('backpacker.reward')" prop="rewardAmount" width="110" align="right">
        <template #default="scope">
          <span>Rp {{ scope.row.rewardAmount }}</span>
        </template>
      </el-table-column>
      <el-table-column :label="t('backpacker.creator')" prop="creatorName" width="110" align="center" />
      <el-table-column :label="t('backpacker.executor')" prop="executorName" width="110" align="center" />
      <el-table-column :label="t('backpacker.location')" prop="locationText" min-width="140" show-overflow-tooltip />
      <el-table-column :label="t('common.time')" align="center" width="160">
        <template #default="scope">
          <span>{{ parseTime(scope.row.createTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column :label="t('common.action')" align="center" width="100" fixed="right">
        <template #default="scope">
          <el-button link type="primary" icon="View" @click="handleDetail(scope.row)" v-hasPermi="['backpacker:order:query']">{{ t('backpacker.detail') }}</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize" @pagination="getList" />

    <el-dialog :title="t('backpacker.detailTitle')" v-model="open" width="640px" append-to-body>
      <el-descriptions :column="1" border v-if="detail">
        <el-descriptions-item :label="t('backpacker.orderNo')">{{ detail.orderNo }}</el-descriptions-item>
        <el-descriptions-item :label="t('common.title')">{{ detail.title }}</el-descriptions-item>
        <el-descriptions-item :label="t('common.status')">
          <dict-tag :options="biz_order_status" :value="detail.status" />
        </el-descriptions-item>
        <el-descriptions-item :label="t('backpacker.searchCategory')">
          <dict-tag :options="biz_order_category" :value="detail.category" />
        </el-descriptions-item>
        <el-descriptions-item :label="t('backpacker.reward')">Rp {{ detail.rewardAmount }}</el-descriptions-item>
        <el-descriptions-item :label="t('backpacker.location')">{{ detail.locationText || '-' }}</el-descriptions-item>
        <el-descriptions-item :label="t('backpacker.creator')">{{ detail.creatorName || '-' }}</el-descriptions-item>
        <el-descriptions-item :label="t('backpacker.executor')">{{ detail.executorName || '-' }}</el-descriptions-item>
        <el-descriptions-item :label="t('backpacker.description')">{{ detail.description || '-' }}</el-descriptions-item>
        <el-descriptions-item :label="t('backpacker.publishedAt')">{{ parseTime(detail.publishedAt) || '-' }}</el-descriptions-item>
        <el-descriptions-item :label="t('backpacker.takenAt')">{{ parseTime(detail.takenAt) || '-' }}</el-descriptions-item>
        <el-descriptions-item :label="t('backpacker.completedAt')">{{ parseTime(detail.completedAt) || '-' }}</el-descriptions-item>
        <el-descriptions-item v-if="detail.ratingScore" :label="t('backpacker.ratingScore')">
          {{ detail.ratingScore }}/5
          <span v-if="detail.ratingComment"> — {{ detail.ratingComment }}</span>
        </el-descriptions-item>
        <el-descriptions-item v-if="detail.cancelReason" :label="t('backpacker.cancelReason')">{{ detail.cancelReason }}</el-descriptions-item>
      </el-descriptions>
      <template #footer>
        <el-button @click="open = false">{{ t('common.close') }}</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="BackpackerOrderList">
import { useI18n } from 'vue-i18n'
import { listOrder, getOrder } from '@/api/backpacker/order'

const { t } = useI18n()
const { proxy } = getCurrentInstance()
const { biz_order_status, biz_order_category } = useDict('biz_order_status', 'biz_order_category')

const orderList = ref([])
const detail = ref(null)
const open = ref(false)
const loading = ref(true)
const showSearch = ref(true)
const total = ref(0)

const queryParams = ref({
  pageNum: 1,
  pageSize: 10,
  orderNo: undefined,
  title: undefined,
  category: undefined,
  status: undefined
})

function getList() {
  loading.value = true
  listOrder(queryParams.value).then(response => {
    orderList.value = response.rows
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

function handleDetail(row) {
  getOrder(row.orderId).then(response => {
    detail.value = response.data
    open.value = true
  })
}

getList()
</script>
