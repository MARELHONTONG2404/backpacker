import request from '@/utils/request'

export function listOrderChat(orderId, query) {
  return request({
    url: '/backpacker/chat/order/' + orderId + '/messages',
    method: 'get',
    params: query
  })
}
