<template>
  <div class="dashboard-container">
    <!-- Sambutan -->
    <el-card class="welcome-card" shadow="never">
      <div class="welcome-inner">
        <div class="welcome-text">
          <h2>{{ t('dashboard.welcome', { name: nickName || name }) }}</h2>
          <p>{{ t('dashboard.subtitle') }}</p>
        </div>
        <div class="welcome-meta">
          <div class="welcome-date">{{ todayLabel }}</div>
          <el-tag type="success" effect="plain" round>{{ t('common.online') }}</el-tag>
        </div>
      </div>
    </el-card>

    <!-- Statistik ringkas -->
    <el-row :gutter="16" class="section-row">
      <el-col v-for="item in statCards" :key="item.key" :xs="12" :sm="6">
        <el-card shadow="hover" class="stat-card" :body-style="{ padding: '20px' }">
          <div class="stat-icon" :style="{ background: item.bg }">
            <el-icon :size="22"><component :is="item.icon" /></el-icon>
          </div>
          <div class="stat-body">
            <div class="stat-value">{{ item.value }}</div>
            <div class="stat-label">{{ item.label }}</div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- Statistik pesanan -->
    <div class="section-title">{{ t('dashboard.sectionOrder') }}</div>
    <el-row :gutter="16" class="section-row">
      <el-col v-for="item in orderStatCards" :key="item.key" :xs="12" :sm="8" :md="4">
        <el-card shadow="hover" class="stat-card report-stat" :body-style="{ padding: '18px' }">
          <div class="stat-icon" :style="{ background: item.bg }">
            <el-icon :size="20"><component :is="item.icon" /></el-icon>
          </div>
          <div class="stat-body">
            <div class="stat-value">{{ item.value }}</div>
            <div class="stat-label">{{ item.label }}</div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- Grafik sistem -->
    <el-row :gutter="16" class="section-row">
      <el-col :xs="24" :lg="16">
        <el-card shadow="never">
          <template #header>
            <div class="card-header">
              <span>{{ t('dashboard.loginChart') }}</span>
            </div>
          </template>
          <div ref="loginChartRef" class="chart-box" v-loading="loading" />
        </el-card>
      </el-col>
      <el-col :xs="24" :lg="8">
        <el-card shadow="never">
          <template #header>
            <div class="card-header">
              <span>{{ t('dashboard.memoryChart') }}</span>
            </div>
          </template>
          <div ref="memoryChartRef" class="chart-box" v-loading="loading" />
        </el-card>
      </el-col>
    </el-row>

    <!-- Grafik pesanan -->
    <el-row :gutter="16" class="section-row">
      <el-col :xs="24" :lg="8">
        <el-card shadow="never">
          <template #header>
            <div class="card-header"><span>{{ t('dashboard.orderStatusChart') }}</span></div>
          </template>
          <div ref="orderStatusChartRef" class="chart-box chart-box-sm" v-loading="loading" />
        </el-card>
      </el-col>
      <el-col :xs="24" :lg="16">
        <el-card shadow="never">
          <template #header>
            <div class="card-header"><span>{{ t('dashboard.orderMonthChart') }}</span></div>
          </template>
          <div ref="orderMonthChartRef" class="chart-box chart-box-sm" v-loading="loading" />
        </el-card>
      </el-col>
    </el-row>

    <!-- Pengumuman & log login -->
    <el-row :gutter="16" class="section-row">
      <el-col :xs="24" :lg="12">
        <el-card shadow="never">
          <template #header>
            <div class="card-header">
              <span>{{ t('dashboard.notices') }}</span>
              <el-badge v-if="unreadCount > 0" :value="unreadCount" class="badge-item" />
            </div>
          </template>
          <el-table :data="notices" v-loading="loading" size="small" :show-header="true">
            <el-table-column :label="t('common.title')" prop="noticeTitle" show-overflow-tooltip>
              <template #default="{ row }">
                <span class="notice-title" @click="openNotice(row)">{{ row.noticeTitle }}</span>
                <el-tag v-if="!row.isRead" size="small" type="danger" class="ml-4">{{ t('common.new') }}</el-tag>
              </template>
            </el-table-column>
            <el-table-column :label="t('common.type')" width="80" align="center">
              <template #default="{ row }">
                <el-tag :type="row.noticeType === '1' ? 'warning' : 'success'" size="small">
                  {{ row.noticeType === '1' ? t('common.notif') : t('common.info') }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column :label="t('common.time')" width="110" align="center">
              <template #default="{ row }">
                <span>{{ formatDate(row.createTime) }}</span>
              </template>
            </el-table-column>
          </el-table>
          <el-empty v-if="!loading && notices.length === 0" :description="t('dashboard.noNotices')" />
        </el-card>
      </el-col>
      <el-col :xs="24" :lg="12">
        <el-card shadow="never">
          <template #header>
            <div class="card-header">
              <span>{{ t('dashboard.recentLogin') }}</span>
            </div>
          </template>
          <el-table :data="recentLogins" v-loading="loading" size="small">
            <el-table-column :label="t('dashboard.user')" prop="userName" width="100" show-overflow-tooltip />
            <el-table-column :label="t('dashboard.ip')" prop="ipaddr" width="120" show-overflow-tooltip />
            <el-table-column :label="t('common.status')" width="80" align="center">
              <template #default="{ row }">
                <el-tag :type="row.status === '0' ? 'success' : 'danger'" size="small">
                  {{ row.status === '0' ? t('common.successTag') : t('common.failTag') }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column :label="t('common.time')" align="center">
              <template #default="{ row }">
                <span>{{ formatDate(row.loginTime) }}</span>
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-col>
    </el-row>

    <!-- Akses cepat -->
    <el-card shadow="never" class="section-row">
      <template #header>
        <div class="card-header"><span>{{ t('dashboard.quickAccess') }}</span></div>
      </template>
      <div class="quick-links">
        <el-button v-for="link in quickLinks" :key="link.path" @click="goTo(link.path)">
          <el-icon class="mr-4"><component :is="link.icon" /></el-icon>
          {{ link.label }}
        </el-button>
      </div>
    </el-card>

    <!-- Dialog pengumuman -->
    <el-dialog v-model="noticeVisible" :title="currentNotice.noticeTitle" width="600px" append-to-body>
      <div class="notice-meta">
        <el-tag size="small" :type="currentNotice.noticeType === '1' ? 'warning' : 'success'">
          {{ currentNotice.noticeType === '1' ? t('dashboard.notification') : t('dashboard.announcement') }}
        </el-tag>
        <span class="notice-time">{{ formatDate(currentNotice.createTime) }}</span>
      </div>
      <div class="notice-content" v-html="currentNotice.noticeContent" />
    </el-dialog>
  </div>
</template>

<script setup name="Index">
import { useI18n } from 'vue-i18n'
import * as echarts from 'echarts'
import { User, Monitor, Bell, Key, Setting, UserFilled, Document, Files, CircleCheck, Clock, Warning } from '@element-plus/icons-vue'
import useUserStore from '@/store/modules/user'
import { fetchDashboardData } from '@/api/dashboard'
import { markNoticeRead } from '@/api/system/notice'

const { t } = useI18n()
const router = useRouter()
const userStore = useUserStore()
const { proxy } = getCurrentInstance()

const loading = ref(true)
const name = computed(() => userStore.name)
const nickName = computed(() => userStore.nickName)

const userCount = ref(0)
const onlineCount = ref(0)
const unreadCount = ref(0)
const loginTodayCount = ref(0)
const notices = ref([])
const recentLogins = ref([])
const serverInfo = ref(null)
const orderStats = ref({
  total: 0,
  published: 0,
  active: 0,
  completed: 0,
  cancelled: 0,
  thisMonth: 0
})

const loginChartRef = ref(null)
const memoryChartRef = ref(null)
const orderStatusChartRef = ref(null)
const orderMonthChartRef = ref(null)
let loginChart = null
let memoryChart = null
let orderStatusChart = null
let orderMonthChart = null

const STATUS_LABELS = computed(() => ({
  DRAFT: t('dashboard.statusDraft'),
  PUBLISHED: t('dashboard.statusPublished'),
  TAKEN: t('dashboard.statusTaken'),
  IN_PROGRESS: t('dashboard.statusInProgress'),
  COMPLETED: t('dashboard.statusCompleted'),
  CANCELLED: t('dashboard.statusCancelled')
}))

const noticeVisible = ref(false)
const currentNotice = ref({})

const todayLabel = new Intl.DateTimeFormat('id-ID', {
  weekday: 'long',
  year: 'numeric',
  month: 'long',
  day: 'numeric'
}).format(new Date())

const statCards = computed(() => [
  { key: 'user', label: t('dashboard.totalUser'), value: userCount.value, icon: User, bg: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)' },
  { key: 'online', label: t('dashboard.userOnline'), value: onlineCount.value, icon: Monitor, bg: 'linear-gradient(135deg, #11998e 0%, #38ef7d 100%)' },
  { key: 'notice', label: t('dashboard.newNotice'), value: unreadCount.value, icon: Bell, bg: 'linear-gradient(135deg, #f093fb 0%, #f5576c 100%)' },
  { key: 'login', label: t('dashboard.loginToday'), value: loginTodayCount.value, icon: Key, bg: 'linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)' }
])

const orderStatCards = computed(() => [
  { key: 'ototal', label: t('dashboard.totalOrder'), value: orderStats.value.total, icon: Files, bg: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)' },
  { key: 'opublished', label: t('dashboard.published'), value: orderStats.value.published, icon: Clock, bg: 'linear-gradient(135deg, #f7971e 0%, #ffd200 100%)' },
  { key: 'oactive', label: t('dashboard.active'), value: orderStats.value.active, icon: Document, bg: 'linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)' },
  { key: 'ocompleted', label: t('dashboard.completed'), value: orderStats.value.completed, icon: CircleCheck, bg: 'linear-gradient(135deg, #11998e 0%, #38ef7d 100%)' },
  { key: 'omonth', label: t('dashboard.thisMonth'), value: orderStats.value.thisMonth, icon: Warning, bg: 'linear-gradient(135deg, #f093fb 0%, #f5576c 100%)' }
])

const quickLinks = computed(() => [
  { label: t('dashboard.quickOrders'), path: '/backpacker/order', icon: Files },
  { label: t('dashboard.quickUser'), path: '/system/user', icon: User },
  { label: t('dashboard.quickRole'), path: '/system/role', icon: UserFilled },
  { label: t('dashboard.quickNotice'), path: '/system/notice', icon: Bell },
  { label: t('dashboard.quickLoginLog'), path: '/monitor/logininfor', icon: Document },
  { label: t('dashboard.quickConfig'), path: '/system/config', icon: Setting }
])

function formatDate(val) {
  return val ? proxy.parseTime(val, '{y}-{m}-{d} {h}:{i}') : '-'
}

function goTo(path) {
  router.push(path)
}

function openNotice(row) {
  currentNotice.value = row
  noticeVisible.value = true
  if (!row.isRead) {
    markNoticeRead(row.noticeId).then(() => {
      row.isRead = true
      unreadCount.value = Math.max(0, unreadCount.value - 1)
    })
  }
}

function buildLoginTrend(logs) {
  const days = []
  const counts = []
  for (let i = 6; i >= 0; i--) {
    const d = new Date()
    d.setDate(d.getDate() - i)
    const key = d.toISOString().slice(0, 10)
    days.push(d.toLocaleDateString('id-ID', { weekday: 'short', day: 'numeric', month: 'short' }))
    counts.push(
      logs.filter(log => log.status === '0' && log.loginTime && log.loginTime.startsWith(key)).length
    )
  }
  return { days, counts }
}

function countLoginToday(logs) {
  const today = new Date().toISOString().slice(0, 10)
  return logs.filter(log => log.status === '0' && log.loginTime && log.loginTime.startsWith(today)).length
}

function initLoginChart(days, counts) {
  if (!loginChartRef.value) return
  loginChart = echarts.init(loginChartRef.value)
  loginChart.setOption({
    tooltip: { trigger: 'axis' },
    grid: { left: '3%', right: '4%', bottom: '3%', top: '12%', containLabel: true },
    xAxis: {
      type: 'category',
      boundaryGap: false,
      data: days,
      axisLine: { lineStyle: { color: '#dcdfe6' } }
    },
    yAxis: {
      type: 'value',
      minInterval: 1,
      splitLine: { lineStyle: { type: 'dashed', color: '#ebeef5' } }
    },
    series: [{
      name: t('dashboard.loginSuccessLine'),
      type: 'line',
      smooth: true,
      symbol: 'circle',
      symbolSize: 8,
      data: counts,
      areaStyle: {
        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
          { offset: 0, color: 'rgba(64, 158, 255, 0.35)' },
          { offset: 1, color: 'rgba(64, 158, 255, 0.05)' }
        ])
      },
      lineStyle: { width: 3, color: '#409EFF' },
      itemStyle: { color: '#409EFF' }
    }]
  })
}

function initMemoryChart(server) {
  if (!memoryChartRef.value) return
  const usage = server?.mem?.usage ?? 0
  memoryChart = echarts.init(memoryChartRef.value)
  memoryChart.setOption({
    series: [{
      type: 'gauge',
      min: 0,
      max: 100,
      progress: { show: true, width: 14 },
      axisLine: { lineStyle: { width: 14 } },
      axisTick: { show: false },
      splitLine: { length: 10, lineStyle: { width: 2, color: '#999' } },
      axisLabel: { distance: 20, color: '#999', fontSize: 11 },
      anchor: { show: true, size: 18, itemStyle: { borderWidth: 2 } },
      pointer: { length: '55%', width: 5 },
      detail: {
        valueAnimation: true,
        fontSize: 22,
        offsetCenter: [0, '70%'],
        formatter: '{value}%'
      },
      data: [{ value: usage, name: t('dashboard.memory') }]
    }]
  })
}

function initOrderStatusChart(statusRows) {
  if (!orderStatusChartRef.value) return
  const labels = STATUS_LABELS.value
  const data = (statusRows || []).map(row => ({
    name: labels[row.name] || row.name,
    value: Number(row.value) || 0
  }))
  if (!data.length) {
    data.push({ name: t('dashboard.noChartData'), value: 0 })
  }
  orderStatusChart = echarts.init(orderStatusChartRef.value)
  orderStatusChart.setOption({
    tooltip: { trigger: 'item', formatter: '{b}: {c} ({d}%)' },
    legend: { bottom: 0, left: 'center' },
    color: ['#909399', '#409EFF', '#E6A23C', '#67C23A', '#F56C6C', '#b88230'],
    series: [{
      type: 'pie',
      radius: ['40%', '65%'],
      center: ['50%', '45%'],
      data,
      label: { formatter: '{b}\n{c}' }
    }]
  })
}

function initOrderMonthChart(monthlyRows) {
  if (!orderMonthChartRef.value) return
  const months = (monthlyRows || []).map(r => r.month)
  const counts = (monthlyRows || []).map(r => Number(r.count) || 0)
  orderMonthChart = echarts.init(orderMonthChartRef.value)
  orderMonthChart.setOption({
    tooltip: { trigger: 'axis' },
    grid: { left: '3%', right: '4%', bottom: '3%', top: '12%', containLabel: true },
    xAxis: { type: 'category', data: months },
    yAxis: { type: 'value', minInterval: 1 },
    series: [{
      name: t('dashboard.orderLabel'),
      type: 'bar',
      barWidth: '45%',
      data: counts,
      itemStyle: {
        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
          { offset: 0, color: '#409EFF' },
          { offset: 1, color: '#79bbff' }
        ]),
        borderRadius: [4, 4, 0, 0]
      }
    }]
  })
}

function handleResize() {
  loginChart?.resize()
  memoryChart?.resize()
  orderStatusChart?.resize()
  orderMonthChart?.resize()
}

async function loadDashboard() {
  loading.value = true
  try {
    const [userRes, onlineRes, noticeRes, loginRes, serverRes, orderRes] = await fetchDashboardData()

    userCount.value = userRes.total ?? 0
    onlineCount.value = onlineRes.total ?? 0
    notices.value = noticeRes.data ?? noticeRes.rows ?? []
    unreadCount.value = noticeRes.unreadCount ?? 0

    if (orderRes?.data) {
      orderStats.value = {
        total: orderRes.data.total ?? 0,
        published: orderRes.data.published ?? 0,
        active: orderRes.data.active ?? 0,
        completed: orderRes.data.completed ?? 0,
        cancelled: orderRes.data.cancelled ?? 0,
        thisMonth: orderRes.data.thisMonth ?? 0
      }
    }

    const logs = loginRes.rows ?? []
    recentLogins.value = logs.slice(0, 8)
    loginTodayCount.value = countLoginToday(logs)
    serverInfo.value = serverRes?.data ?? null

    await nextTick()
    const trend = buildLoginTrend(logs)
    initLoginChart(trend.days, trend.counts)
    initMemoryChart(serverInfo.value)
    initOrderStatusChart(orderRes?.data?.statusChart)
    initOrderMonthChart(orderRes?.data?.monthlyChart)
  } catch (e) {
    console.error(e)
    proxy.$modal.msgError(t('common.loadFailed'))
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  loadDashboard()
  window.addEventListener('resize', handleResize)
})

onBeforeUnmount(() => {
  window.removeEventListener('resize', handleResize)
  loginChart?.dispose()
  memoryChart?.dispose()
  orderStatusChart?.dispose()
  orderMonthChart?.dispose()
})
</script>

<style scoped lang="scss">
.dashboard-container {
  padding: 4px;
}

.welcome-card {
  border: none;
  background: linear-gradient(135deg, #1d2b64 0%, #2d6a9f 55%, #409eff 100%);
  color: #fff;

  :deep(.el-card__body) {
    padding: 24px 28px;
  }
}

.welcome-inner {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 16px;
}

.welcome-text h2 {
  margin: 0 0 8px;
  font-size: 22px;
  font-weight: 600;
}

.welcome-text p {
  margin: 0;
  opacity: 0.9;
  font-size: 14px;
}

.welcome-meta {
  text-align: right;
}

.welcome-date {
  font-size: 13px;
  opacity: 0.9;
  margin-bottom: 8px;
}

.section-row {
  margin-top: 16px;
}

.stat-card {
  :deep(.el-card__body) {
    display: flex;
    align-items: center;
    gap: 16px;
  }
}

.stat-icon {
  width: 48px;
  height: 48px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  flex-shrink: 0;
}

.stat-value {
  font-size: 26px;
  font-weight: 700;
  color: #303133;
  line-height: 1.2;
}

.stat-label {
  font-size: 13px;
  color: #909399;
  margin-top: 4px;
}

.card-header {
  display: flex;
  align-items: center;
  gap: 8px;
  font-weight: 600;
}

.section-title {
  margin-top: 20px;
  margin-bottom: 4px;
  font-size: 15px;
  font-weight: 600;
  color: #303133;
}

.chart-box-sm {
  height: 280px;
}

.report-stat .stat-value {
  font-size: 22px;
}

.chart-box {
  height: 320px;
}

.notice-title {
  cursor: pointer;
  color: #409eff;

  &:hover {
    text-decoration: underline;
  }
}

.ml-4 {
  margin-left: 4px;
}

.mr-4 {
  margin-right: 4px;
}

.quick-links {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.notice-meta {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 16px;
}

.notice-time {
  font-size: 13px;
  color: #909399;
}

.notice-content {
  line-height: 1.7;
  color: #606266;
}

@media (max-width: 768px) {
  .welcome-inner {
    flex-direction: column;
    align-items: flex-start;
  }

  .welcome-meta {
    text-align: left;
  }
}
</style>
