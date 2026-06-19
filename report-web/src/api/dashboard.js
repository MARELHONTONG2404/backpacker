import request from '@/utils/request'
import { listUser } from '@/api/system/user'
import { list as listOnline } from '@/api/monitor/online'
import { listNoticeTop } from '@/api/system/notice'
import { list as listLogininfor } from '@/api/monitor/logininfor'
import { getServer } from '@/api/monitor/server'
import { getOrderStats } from '@/api/backpacker/order'

/** Ambil semua data dashboard Backpacker */
export function fetchDashboardData() {
  return Promise.all([
    listUser({ pageNum: 1, pageSize: 1 }),
    listOnline({ pageNum: 1, pageSize: 1 }),
    listNoticeTop(),
    listLogininfor({ pageNum: 1, pageSize: 100 }),
    getServer().catch(() => null),
    getOrderStats().catch(() => null)
  ])
}
