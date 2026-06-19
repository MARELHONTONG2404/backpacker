<template>
   <div class="app-container">
      <h4 class="form-header h4">{{ t('system.auth.basicInfo') }}</h4>
      <el-form :model="form" label-width="80px">
         <el-row>
            <el-col :span="8" :offset="2">
               <el-form-item :label="t('system.user.nickName')" prop="nickName">
                  <el-input v-model="form.nickName" disabled />
               </el-form-item>
            </el-col>
            <el-col :span="8" :offset="2">
               <el-form-item :label="t('system.profile.loginAccount')" prop="userName">
                  <el-input v-model="form.userName" disabled />
               </el-form-item>
            </el-col>
         </el-row>
      </el-form>

      <h4 class="form-header h4">{{ t('system.auth.roleInfo') }}</h4>
      <el-table v-loading="loading" :row-key="getRowKey" @row-click="clickRow" ref="roleRef" @selection-change="handleSelectionChange" :data="roles.slice((pageNum - 1) * pageSize, pageNum * pageSize)">
         <el-table-column :label="t('monitor.serialNo')" width="55" type="index" align="center">
            <template #default="scope">
               <span>{{ (pageNum - 1) * pageSize + scope.$index + 1 }}</span>
            </template>
         </el-table-column>
         <el-table-column type="selection" :reserve-selection="true" :selectable="checkSelectable" width="55"></el-table-column>
         <el-table-column :label="t('system.role.roleId')" align="center" prop="roleId" />
         <el-table-column :label="t('system.role.roleName')" align="center" prop="roleName" />
         <el-table-column :label="t('system.role.roleKey')" align="center" prop="roleKey" />
         <el-table-column :label="t('system.createTime')" align="center" prop="createTime" width="180">
            <template #default="scope">
               <span>{{ parseTime(scope.row.createTime) }}</span>
            </template>
         </el-table-column>
      </el-table>

      <pagination v-show="total > 0" :total="total" v-model:page="pageNum" v-model:limit="pageSize" />

      <el-form label-width="100px">
         <div style="text-align: center;margin-left:-120px;margin-top:30px;">
            <el-button type="primary" @click="submitForm()">{{ t('system.auth.submit') }}</el-button>
            <el-button @click="close()">{{ t('system.auth.back') }}</el-button>
         </div>
      </el-form>
   </div>
</template>

<script setup name="AuthRole">
import { useI18n } from 'vue-i18n'
import { getAuthRole, updateAuthRole } from "@/api/system/user"

const { t } = useI18n()
const route = useRoute()
const { proxy } = getCurrentInstance()

const loading = ref(true)
const total = ref(0)
const pageNum = ref(1)
const pageSize = ref(10)
const roleIds = ref([])
const roles = ref([])
const form = ref({
  nickName: undefined,
  userName: undefined,
  userId: undefined
})

function clickRow(row) {
  if (checkSelectable(row)) {
    proxy.$refs["roleRef"].toggleRowSelection(row)
  }
}

function handleSelectionChange(selection) {
  roleIds.value = selection.map(item => item.roleId)
}

function getRowKey(row) {
  return row.roleId
}

function checkSelectable(row) {
  return row.status === "0" ? true : false
}

function close() {
  const obj = { path: "/system/user" }
  proxy.$tab.closeOpenPage(obj)
}

function submitForm() {
  const userId = form.value.userId
  const rIds = roleIds.value.join(",")
  updateAuthRole({ userId: userId, roleIds: rIds }).then(() => {
    proxy.$modal.msgSuccess(t('system.auth.authSuccess'))
    close()
  })
}

(() => {
  const userId = route.params && route.params.userId
  if (userId) {
    loading.value = true
    getAuthRole(userId).then(response => {
      form.value = response.user
      roles.value = response.roles
      total.value = roles.value.length
      nextTick(() => {
        roles.value.forEach(row => {
          if (row.flag) {
            proxy.$refs["roleRef"].toggleRowSelection(row)
          }
        })
      })
      loading.value = false
    })
  }
})()
</script>
