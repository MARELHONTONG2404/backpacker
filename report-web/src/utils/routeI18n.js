import i18n from '@/locales'
import idMessages from '@/locales/id'
import zhCnMessages from '@/locales/zh-cn'

const MENU_KEY_ALIASES = {
  system_log_operlog: 'monitor_operlog',
  system_log_logininfor: 'monitor_logininfor'
}

export function normalizeRoutePath(path) {
  return (path || '').replace(/\\/g, '/').replace(/\/+/g, '/').replace(/^\/|\/$/g, '')
}

export function pathToMenuKey(path) {
  if (!path) return 'index'
  const segments = normalizeRoutePath(path).replace(/:/g, '_').split('/').filter(Boolean)
  if (segments.length >= 2 && segments.every(segment => segment === segments[0])) {
    return segments[0]
  }
  const normalized = segments.join('_')
  return normalized || 'index'
}

function getMenuDict() {
  const locale = i18n.global.locale.value
  return (locale === 'zh-cn' ? zhCnMessages : idMessages).menu || {}
}

function lookupMenuTranslation(key) {
  if (!key) return null
  const dict = getMenuDict()
  const shortKey = key.replace(/^menu\./, '')
  const candidates = [shortKey]
  if (MENU_KEY_ALIASES[shortKey]) {
    candidates.push(MENU_KEY_ALIASES[shortKey])
  }
  for (const candidate of candidates) {
    if (dict[candidate]) {
      return dict[candidate]
    }
  }
  return null
}

function buildMenuKeyCandidates(path) {
  const candidates = []
  const primary = pathToMenuKey(path)
  candidates.push(primary)

  if (MENU_KEY_ALIASES[primary]) {
    candidates.push(MENU_KEY_ALIASES[primary])
  }

  const segments = normalizeRoutePath(path).split('/').filter(Boolean)
  if (segments.length >= 2 && segments[segments.length - 1] === segments[segments.length - 2]) {
    candidates.push(segments.slice(0, -1).join('_'))
  }

  if (segments.length >= 2) {
    const last = segments[segments.length - 1]
    if (['operlog', 'logininfor', 'online', 'job', 'server', 'cache', 'cacheList'].includes(last)) {
      candidates.push(`monitor_${last}`)
    }
    const parentKey = segments.slice(0, -1).join('_')
    if (parentKey) {
      candidates.push(parentKey)
    }
  }

  return [...new Set(candidates)]
}

export function translateMenuTitle(path, meta = {}) {
  if (meta.titleKey) {
    const fromTitleKey = lookupMenuTranslation(meta.titleKey)
    if (fromTitleKey) {
      return fromTitleKey
    }
  }

  for (const key of buildMenuKeyCandidates(path)) {
    const translated = lookupMenuTranslation(key)
    if (translated) {
      return translated
    }
  }

  return meta.title || ''
}

export function resolveMenuI18nPath(routeItem, basePath = '') {
  const ownPath = routeItem?.path || ''
  const base = basePath || ''
  const normBase = normalizeRoutePath(base)
  const normOwn = normalizeRoutePath(ownPath)

  if (normOwn && normBase === normOwn) {
    return normOwn ? `/${normOwn}` : ''
  }

  if (normOwn && normBase && (normBase.endsWith(`/${normOwn}`) || normBase === normOwn)) {
    return `/${normBase}`
  }

  if (normOwn && !normBase) {
    return `/${normOwn}`
  }

  if (/^(https?:|mailto:|tel:)/.test(ownPath)) {
    return ownPath
  }
  if (/^(https?:|mailto:|tel:)/.test(base)) {
    return base
  }

  const joined = [base, ownPath].filter(Boolean).join('/').replace(/\/+/g, '/')
  const normalized = joined.startsWith('/') ? joined : `/${joined}`
  return normalized.replace(/\/+/g, '/')
}

export function applyRouteTitleTranslations(routes = []) {
  routes.forEach(route => translateRouteNode(route))
  return routes
}

function translateRouteNode(route, parentPath = '') {
  if (!route) return

  const segment = normalizeRoutePath(route.path)
  const fullPath = segment
    ? (parentPath ? `${parentPath}/${segment}` : segment)
    : parentPath

  if (route.meta) {
    const i18nPath = fullPath ? `/${fullPath}` : route.path
    const translated = translateMenuTitle(i18nPath, route.meta)
    if (translated) {
      route.meta.title = translated
    }
  }

  if (Array.isArray(route.children)) {
    route.children.forEach(child => translateRouteNode(child, fullPath))
  }
}
