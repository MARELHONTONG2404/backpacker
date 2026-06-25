import auth from '@/plugins/auth'
import router, { constantRoutes, dynamicRoutes } from '@/router'
import { getRouters } from '@/api/menu'
import { applyRouteTitleTranslations } from '@/utils/routeI18n'
import Layout from '@/layout/index'
import ParentView from '@/components/ParentView'
import InnerLink from '@/layout/components/InnerLink'

// 匹配views里面所有的.vue文件
const modules = import.meta.glob('./../../views/**/*.vue')

const usePermissionStore = defineStore(
  'permission',
  {
    state: () => ({
      routes: [],
      addRoutes: [],
      defaultRoutes: [],
      topbarRouters: [],
      sidebarRouters: []
    }),
    actions: {
      setRoutes(routes) {
        this.addRoutes = routes
        this.routes = constantRoutes.concat(routes)
      },
      setDefaultRoutes(routes) {
        this.defaultRoutes = constantRoutes.concat(routes)
      },
      setTopbarRoutes(routes) {
        this.topbarRouters = routes
      },
      setSidebarRouters(routes) {
        this.sidebarRouters = routes
      },
      generateRoutes(roles) {
        return new Promise(resolve => {
          getRouters().then(res => {
            const sdata = JSON.parse(JSON.stringify(res.data))
            const rdata = JSON.parse(JSON.stringify(res.data))
            const defaultData = JSON.parse(JSON.stringify(res.data))
            applyRouteTitleTranslations(sdata)
            applyRouteTitleTranslations(rdata)
            applyRouteTitleTranslations(defaultData)
            normalizeBackpackerRouteNames(sdata)
            normalizeBackpackerRouteNames(rdata)
            normalizeBackpackerRouteNames(defaultData)
            const sidebarRoutes = filterAsyncRouter(sdata)
            const rewriteRoutes = filterAsyncRouter(rdata, false, true)
            const defaultRoutes = filterAsyncRouter(defaultData)
            const asyncRoutes = filterDynamicRoutes(dynamicRoutes)
            asyncRoutes.forEach(route => { router.addRoute(route) })
            this.setRoutes(rewriteRoutes)
            this.setSidebarRouters(constantRoutes.concat(sidebarRoutes))
            this.setDefaultRoutes(sidebarRoutes)
            this.setTopbarRoutes(defaultRoutes)
            if (!router.hasRoute('NotFound')) {
              router.addRoute({
                path: '/:pathMatch(.*)*',
                component: Layout,
                hidden: true,
                children: [
                  {
                    path: '',
                    name: 'NotFound',
                    component: () => import('@/views/error/404'),
                    meta: { title: '404', titleKey: 'pages.page404Title' }
                  }
                ]
              })
            }
            resolve(rewriteRoutes)
          })
        })
      },
      refreshRoutes() {
        return this.generateRoutes()
      }
    }
  })

/** Pisahkan route name/path menu backpacker dari profil admin. */
function normalizeBackpackerRouteNames(routes, parentPath = '') {
  routes.forEach(route => {
    const segment = String(route.path || '')
    const fullPath = segment.startsWith('/')
      ? segment
      : `${parentPath}/${segment}`.replace(/\/+/g, '/')
    const component = String(route.component || '')
    const isBackpackerProfileMenu =
      component.includes('backpacker/profile') ||
      (fullPath.includes('/backpacker') && (segment === 'profile' || segment === 'users'))
    if (isBackpackerProfileMenu) {
      route.name = 'BackpackerProfile'
    } else if (route.name === 'Profile') {
      route.name = 'BackpackerProfile'
    }
    if (route.children && route.children.length) {
      normalizeBackpackerRouteNames(route.children, fullPath)
    }
  })
  return routes
}

// 遍历后台传来的路由字符串，转换为组件对象
function filterAsyncRouter(asyncRouterMap, lastRouter = false, type = false) {
  return asyncRouterMap.filter(route => {
    if (type && route.children) {
      route.children = filterChildren(route.children)
    }
    if (route.component) {
      // Layout ParentView 组件特殊处理
      if (route.component === 'Layout') {
        route.component = Layout
      } else if (route.component === 'ParentView') {
        route.component = ParentView
      } else if (route.component === 'InnerLink') {
        route.component = InnerLink
      } else {
        route.component = loadView(route.component)
      }
    }
    if (route.children != null && route.children && route.children.length) {
      route.children = filterAsyncRouter(route.children, route, type)
    } else {
      delete route['children']
      delete route['redirect']
    }
    return true
  })
}

function filterChildren(childrenMap, lastRouter = false) {
  var children = []
  childrenMap.forEach(el => {
    el.path = lastRouter ? lastRouter.path + '/' + el.path : el.path
    if (el.children && el.children.length && el.component === 'ParentView') {
      children = children.concat(filterChildren(el.children, el))
    } else {
      children.push(el)
    }
  })
  return children
}

// 动态路由遍历，验证是否具备权限
export function filterDynamicRoutes(routes) {
  const res = []
  routes.forEach(route => {
    if (route.permissions) {
      if (auth.hasPermiOr(route.permissions)) {
        res.push(route)
      }
    } else if (route.roles) {
      if (auth.hasRoleOr(route.roles)) {
        res.push(route)
      }
    }
  })
  return res
}

export const loadView = (view) => {
  let res
  for (const path in modules) {
    const dir = path.split('views/')[1].split('.vue')[0]
    if (dir === view) {
      res = () => modules[path]()
    }
  }
  return res
}

export default usePermissionStore
