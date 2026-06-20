import request from '@/utils/request'

export function listCoinTransaction(query) {
  return request({
    url: '/backpacker/coin/list',
    method: 'get',
    params: query
  })
}
