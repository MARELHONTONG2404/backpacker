<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch">
      <el-form-item :label="t('backpacker.orderNo')" prop="orderNo">
        <el-input v-model="queryParams.orderNo" clearable style="width: 160px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item :label="t('backpacker.executor')" prop="executorName">
        <el-input v-model="queryParams.executorName" clearable style="width: 150px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item :label="t('backpacker.ratingScore')" prop="score">
        <el-select v-model="queryParams.score" clearable style="width: 120px">
          <el-option v-for="n in 5" :key="n" :label="n + ' ★'" :value="n" />
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

    <el-table v-loading="loading" :data="ratingList">
      <el-table-column label="ID" prop="ratingId" width="70" align="center" />
      <el-table-column :label="t('backpacker.orderNo')" prop="orderNo" width="160" show-overflow-tooltip />
      <el-table-column :label="t('common.title')" prop="orderTitle" min-width="160" show-overflow-tooltip />
      <el-table-column :label="t('backpacker.creator')" prop="raterName" width="120" align="center" />
      <el-table-column :label="t('backpacker.executor')" prop="executorName" width="120" align="center" />
      <el-table-column :label="t('backpacker.ratingScore')" prop="score" width="140" align="center">
        <template #default="scope">
          <el-rate :model-value="scope.row.score" disabled />
        </template>
      </el-table-column>
      <el-table-column :label="t('backpacker.ratingComment')" prop="comment" min-width="160" show-overflow-tooltip />
      <el-table-column :label="t('common.time')" align="center" width="160">
        <template #default="scope">
          <span>{{ parseTime(scope.row.createTime) }}</span>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize" @pagination="getList" />
  </div>
</template>

<script setup name="BackpackerRatingList">
import { useI18n } from 'vue-i18n'
import { listRating } from '@/api/backpacker/rating'

const { t } = useI18n()
const { proxy } = getCurrentInstance()

const ratingList = ref([])
const loading = ref(true)
const showSearch = ref(true)
const total = ref(0)

const queryParams = ref({
  pageNum: 1,
  pageSize: 10,
  orderNo: undefined,
  executorName: undefined,
  score: undefined
})

function getList() {
  loading.value = true
  listRating(queryParams.value).then(response => {
    ratingList.value = response.rows
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
