import request from '@/utils/request'
import { listUser } from '@/api/system/user'
import { list as listOnline } from '@/api/monitor/online'
import { listNoticeTop } from '@/api/system/notice'
import { list as listLogininfor } from '@/api/monitor/logininfor'
import { getServer } from '@/api/monitor/server'
import { getReportStats } from '@/api/report/report'

/** Ambil semua data dashboard dari API yang sudah ada */
export function fetchDashboardData() {
  return Promise.all([
    listUser({ pageNum: 1, pageSize: 1 }),
    listOnline({ pageNum: 1, pageSize: 1 }),
    listNoticeTop(),
    listLogininfor({ pageNum: 1, pageSize: 100 }),
    getServer().catch(() => null),
    getReportStats().catch(() => null)
  ])
}
