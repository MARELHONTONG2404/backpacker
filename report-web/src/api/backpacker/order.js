import request from '@/utils/request'

export function listOrder(query) {
  return request({
    url: '/backpacker/order/list',
    method: 'get',
    params: query
  })
}

export function getOrder(orderId) {
  return request({
    url: '/backpacker/order/' + orderId,
    method: 'get'
  })
}
