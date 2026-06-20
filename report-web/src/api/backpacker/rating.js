import request from '@/utils/request'

export function listRating(query) {
  return request({
    url: '/backpacker/rating/list',
    method: 'get',
    params: query
  })
}
