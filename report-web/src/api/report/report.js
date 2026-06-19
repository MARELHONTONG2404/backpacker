import request from '@/utils/request'

export function listReport(query) {
  return request({
    url: '/report/report/list',
    method: 'get',
    params: query
  })
}

export function getReport(reportId) {
  return request({
    url: '/report/report/' + reportId,
    method: 'get'
  })
}

export function getReportStats() {
  return request({
    url: '/report/report/stats',
    method: 'get'
  })
}

export function addReport(data) {
  return request({
    url: '/report/report',
    method: 'post',
    data: data
  })
}

export function updateReport(data) {
  return request({
    url: '/report/report',
    method: 'put',
    data: data
  })
}

export function delReport(reportIds) {
  return request({
    url: '/report/report/' + reportIds,
    method: 'delete'
  })
}
