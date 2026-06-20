<template>
  <div class="app-container">
    <el-row :gutter="16" class="mb8">
      <el-col :span="6">
        <el-card shadow="never">
          <div class="stat-label">{{ t('backpacker.totalProfiles') }}</div>
          <div class="stat-value">{{ stats.totalProfiles ?? '-' }}</div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="never">
          <div class="stat-label">{{ t('backpacker.totalCoins') }}</div>
          <div class="stat-value">{{ stats.totalCoins ?? '-' }}</div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="never">
          <div class="stat-label">{{ t('backpacker.avgReputation') }}</div>
          <div class="stat-value">{{ stats.avgReputation ?? '-' }}</div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="never">
          <div class="stat-label">{{ t('backpacker.lowReputation') }}</div>
          <div class="stat-value text-danger">{{ stats.lowReputation ?? '-' }}</div>
        </el-card>
      </el-col>
    </el-row>

    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch">
      <el-form-item :label="t('system.user.userName')" prop="userName">
        <el-input v-model="queryParams.userName" clearable style="width: 160px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item :label="t('system.user.nickName')" prop="nickName">
        <el-input v-model="queryParams.nickName" clearable style="width: 160px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">{{ t('common.search') }}</el-button>
        <el-button icon="Refresh" @click="resetQuery">{{ t('common.reset') }}</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList" />
    </el-row>

    <el-table v-loading="loading" :data="profileList">
      <el-table-column label="ID" prop="userId" width="70" align="center" />
      <el-table-column :label="t('system.user.userName')" prop="userName" width="120" />
      <el-table-column :label="t('system.user.nickName')" prop="nickName" width="140" />
      <el-table-column :label="t('backpacker.copperCoins')" prop="copperCoins" width="110" align="center" />
      <el-table-column :label="t('backpacker.reputationScore')" prop="reputationScore" width="110" align="center">
        <template #default="scope">
          <el-tag :type="scope.row.reputationScore < 60 ? 'danger' : 'success'">{{ scope.row.reputationScore }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column :label="t('backpacker.completedTasks')" prop="completedTasks" width="110" align="center" />
      <el-table-column :label="t('backpacker.failedTasks')" prop="failedTasks" width="110" align="center" />
      <el-table-column :label="t('backpacker.lastCheckin')" align="center" width="120">
        <template #default="scope">
          <span>{{ scope.row.lastCheckinDate || '-' }}</span>
        </template>
      </el-table-column>
      <el-table-column :label="t('common.action')" align="center" width="100" fixed="right">
        <template #default="scope">
          <el-button link type="primary" icon="View" @click="handleDetail(scope.row)" v-hasPermi="['backpacker:profile:query']">{{ t('backpacker.detail') }}</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize" @pagination="getList" />

    <el-dialog :title="t('backpacker.profileDetailTitle')" v-model="open" width="560px" append-to-body>
      <el-descriptions :column="1" border v-if="detail">
        <el-descriptions-item label="ID">{{ detail.userId }}</el-descriptions-item>
        <el-descriptions-item :label="t('system.user.userName')">{{ detail.userName }}</el-descriptions-item>
        <el-descriptions-item :label="t('system.user.nickName')">{{ detail.nickName }}</el-descriptions-item>
        <el-descriptions-item :label="t('system.phone')">{{ detail.phonenumber || '-' }}</el-descriptions-item>
        <el-descriptions-item :label="t('backpacker.copperCoins')">{{ detail.copperCoins }}</el-descriptions-item>
        <el-descriptions-item :label="t('backpacker.reputationScore')">{{ detail.reputationScore }}</el-descriptions-item>
        <el-descriptions-item :label="t('backpacker.completedTasks')">{{ detail.completedTasks }}</el-descriptions-item>
        <el-descriptions-item :label="t('backpacker.failedTasks')">{{ detail.failedTasks }}</el-descriptions-item>
        <el-descriptions-item :label="t('backpacker.lastCheckin')">{{ detail.lastCheckinDate || '-' }}</el-descriptions-item>
      </el-descriptions>
      <template #footer>
        <el-button @click="open = false">{{ t('common.close') }}</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="BackpackerProfileList">
import { useI18n } from 'vue-i18n'
import { listProfile, getProfile, getGamificationStats } from '@/api/backpacker/profile'

const { t } = useI18n()
const { proxy } = getCurrentInstance()

const profileList = ref([])
const detail = ref(null)
const stats = ref({})
const open = ref(false)
const loading = ref(true)
const showSearch = ref(true)
const total = ref(0)

const queryParams = ref({
  pageNum: 1,
  pageSize: 10,
  userName: undefined,
  nickName: undefined
})

function loadStats() {
  getGamificationStats().then(response => {
    stats.value = response.data || {}
  })
}

function getList() {
  loading.value = true
  listProfile(queryParams.value).then(response => {
    profileList.value = response.rows
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
  getProfile(row.userId).then(response => {
    detail.value = response.data
    open.value = true
  })
}

loadStats()
getList()
</script>

<style scoped>
.stat-label {
  color: #909399;
  font-size: 13px;
  margin-bottom: 8px;
}
.stat-value {
  font-size: 24px;
  font-weight: 600;
}
.text-danger {
  color: #f56c6c;
}
</style>
