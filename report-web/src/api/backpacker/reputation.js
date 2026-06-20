import request from '@/utils/request'

export function listReputationLog(query) {
  return request({
    url: '/backpacker/reputation/list',
    method: 'get',
    params: query
  })
}
