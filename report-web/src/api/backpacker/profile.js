import request from '@/utils/request'

export function listProfile(query) {
  return request({
    url: '/backpacker/profile/list',
    method: 'get',
    params: query
  })
}

export function getProfile(userId) {
  return request({
    url: '/backpacker/profile/' + userId,
    method: 'get'
  })
}

export function getGamificationStats() {
  return request({
    url: '/backpacker/profile/stats',
    method: 'get'
  })
}

export function adjustCoins(data) {
  return request({
    url: '/backpacker/profile/adjust-coins',
    method: 'post',
    data
  })
}

export function adjustReputation(data) {
  return request({
    url: '/backpacker/profile/adjust-reputation',
    method: 'post',
    data
  })
}
