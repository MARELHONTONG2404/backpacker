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

    <p v-if="isMobile" class="table-scroll-hint">{{ t('backpacker.mobileSwipeHint') }}</p>

    <!-- Tampilan kartu untuk handphone -->
    <div v-if="isMobile" v-loading="loading" class="mobile-card-list">
      <el-empty v-if="!loading && orderList.length === 0" :description="t('common.noData')" />
      <el-card v-for="row in orderList" :key="row.orderId" shadow="hover" class="mobile-order-card" @click="handleDetail(row)">
        <div class="mobile-card-head">
          <span class="mobile-card-title">{{ row.title }}</span>
          <dict-tag :options="biz_order_status" :value="row.status" />
        </div>
        <div class="mobile-card-meta">{{ row.orderNo }}</div>
        <div class="mobile-card-row">
          <span>{{ t('backpacker.reward') }}</span>
          <strong>Rp {{ row.rewardAmount }}</strong>
        </div>
        <div class="mobile-card-row">
          <span>{{ t('backpacker.creator') }} / {{ t('backpacker.executor') }}</span>
          <span>{{ row.creatorName || '-' }} → {{ row.executorName || '-' }}</span>
        </div>
        <div class="mobile-card-foot">
          <dict-tag :options="biz_order_category" :value="row.category" size="small" />
          <span>{{ parseTime(row.createTime) }}</span>
        </div>
        <el-button type="primary" link class="mobile-card-action" @click.stop="handleDetail(row)">
          {{ t('backpacker.detail') }}
        </el-button>
      </el-card>
    </div>

    <el-table v-else v-loading="loading" :data="orderList">
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

    <el-dialog :title="t('backpacker.detailTitle')" v-model="open" :width="isMobile ? '100%' : '760px'" :fullscreen="isMobile" append-to-body>
      <el-tabs v-if="detail">
        <el-tab-pane :label="t('backpacker.detail')">
          <el-descriptions :column="1" border>
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
        </el-tab-pane>
        <el-tab-pane :label="t('backpacker.chatMonitorTitle')">
          <div v-loading="chatLoading" class="chat-monitor">
            <el-empty v-if="!chatLoading && chatMessages.length === 0" :description="t('backpacker.chatMonitorEmpty')" />
            <div v-for="msg in chatMessages" :key="msg.messageId" class="chat-monitor-item">
              <div class="chat-monitor-meta">
                <strong>{{ msg.senderName || '-' }}</strong>
                <span>{{ parseTime(msg.createTime) }}</span>
              </div>
              <div v-if="msg.imageUrl" class="chat-monitor-image">
                <el-image :src="msg.imageUrl" fit="cover" :preview-src-list="[msg.imageUrl]" style="max-width: 220px; border-radius: 8px;" />
              </div>
              <div v-if="msg.content" class="chat-monitor-content">{{ msg.content }}</div>
              <div v-else-if="msg.messageType === 'IMAGE'" class="chat-monitor-content">{{ t('backpacker.chatMessageImage') }}</div>
            </div>
          </div>
        </el-tab-pane>
      </el-tabs>
      <template #footer>
        <el-button @click="open = false">{{ t('common.close') }}</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="BackpackerOrderList">
import { useI18n } from 'vue-i18n'
import { listOrder, getOrder } from '@/api/backpacker/order'
import { listOrderChat } from '@/api/backpacker/chat'
import useAppStore from '@/store/modules/app'

const { t } = useI18n()
const appStore = useAppStore()
const isMobile = computed(() => appStore.device === 'mobile')
const { proxy } = getCurrentInstance()
const { biz_order_status, biz_order_category } = useDict('biz_order_status', 'biz_order_category')

const orderList = ref([])
const detail = ref(null)
const chatMessages = ref([])
const open = ref(false)
const loading = ref(true)
const chatLoading = ref(false)
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

function loadChat(orderId) {
  chatLoading.value = true
  chatMessages.value = []
  listOrderChat(orderId, { limit: 200 }).then(response => {
    chatMessages.value = response.data || []
    chatLoading.value = false
  }).catch(() => {
    chatLoading.value = false
  })
}

function handleDetail(row) {
  getOrder(row.orderId).then(response => {
    detail.value = response.data
    open.value = true
    loadChat(row.orderId)
  })
}

getList()
</script>

<style scoped>
.chat-monitor {
  max-height: 420px;
  overflow-y: auto;
  padding: 4px 2px;
}

.chat-monitor-item {
  border: 1px solid var(--el-border-color-light);
  border-radius: 10px;
  padding: 10px 12px;
  margin-bottom: 10px;
}

.chat-monitor-meta {
  display: flex;
  justify-content: space-between;
  gap: 12px;
  margin-bottom: 6px;
  font-size: 12px;
  color: var(--el-text-color-secondary);
}

.chat-monitor-content {
  white-space: pre-wrap;
  line-height: 1.5;
}

.chat-monitor-image {
  margin-bottom: 8px;
}

.mobile-card-list {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.mobile-order-card {
  cursor: pointer;

  :deep(.el-card__body) {
    padding: 14px;
  }
}

.mobile-card-head {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 8px;
  margin-bottom: 6px;
}

.mobile-card-title {
  font-weight: 600;
  font-size: 15px;
  line-height: 1.35;
  flex: 1;
}

.mobile-card-meta {
  font-size: 12px;
  color: var(--el-text-color-secondary);
  margin-bottom: 10px;
}

.mobile-card-row {
  display: flex;
  justify-content: space-between;
  gap: 8px;
  font-size: 13px;
  margin-bottom: 6px;
  color: var(--el-text-color-regular);
}

.mobile-card-foot {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 8px;
  margin-top: 10px;
  font-size: 12px;
  color: var(--el-text-color-secondary);
}

.mobile-card-action {
  margin-top: 8px;
  padding-left: 0;
}
</style>
