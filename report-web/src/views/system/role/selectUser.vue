<template>
   <el-dialog :title="t('system.auth.selectUser')" v-model="visible" width="800px" top="5vh" append-to-body>
      <el-form :model="queryParams" ref="queryRef" :inline="true">
         <el-form-item :label="t('system.user.userName')" prop="userName">
            <el-input
               v-model="queryParams.userName"
               :placeholder="t('system.user.userNamePlaceholder')"
               clearable
               style="width: 180px"
               @keyup.enter="handleQuery"
            />
         </el-form-item>
         <el-form-item :label="t('system.phone')" prop="phonenumber">
            <el-input
               v-model="queryParams.phonenumber"
               :placeholder="t('system.user.phonePlaceholder')"
               clearable
               style="width: 180px"
               @keyup.enter="handleQuery"
            />
         </el-form-item>
         <el-form-item>
            <el-button type="primary" icon="Search" @click="handleQuery">{{ t('common.search') }}</el-button>
            <el-button icon="Refresh" @click="resetQuery">{{ t('common.reset') }}</el-button>
         </el-form-item>
      </el-form>
      <el-row>
         <el-table @row-click="clickRow" ref="refTable" :data="userList" @selection-change="handleSelectionChange" height="260px">
            <el-table-column type="selection" width="55"></el-table-column>
            <el-table-column :label="t('system.user.userName')" prop="userName" :show-overflow-tooltip="true" />
            <el-table-column :label="t('system.user.nickName')" prop="nickName" :show-overflow-tooltip="true" />
            <el-table-column :label="t('system.email')" prop="email" :show-overflow-tooltip="true" />
            <el-table-column :label="t('common.mobile')" prop="phonenumber" :show-overflow-tooltip="true" />
            <el-table-column :label="t('common.status')" align="center" prop="status">
               <template #default="scope">
                  <dict-tag :options="sys_normal_disable" :value="scope.row.status" />
               </template>
            </el-table-column>
            <el-table-column :label="t('system.createTime')" align="center" prop="createTime" width="180">
               <template #default="scope">
                  <span>{{ parseTime(scope.row.createTime) }}</span>
               </template>
            </el-table-column>
         </el-table>
         <pagination
            v-show="total > 0"
            :total="total"
            v-model:page="queryParams.pageNum"
            v-model:limit="queryParams.pageSize"
            @pagination="getList"
         />
      </el-row>
      <template #footer>
         <div class="dialog-footer">
            <el-button type="primary" @click="handleSelectUser">{{ t('common.confirm') }}</el-button>
            <el-button @click="visible = false">{{ t('common.cancel') }}</el-button>
         </div>
      </template>
   </el-dialog>
</template>

<script setup name="SelectUser">
import { useI18n } from 'vue-i18n'
import { authUserSelectAll, unallocatedUserList } from "@/api/system/role"

const { t } = useI18n()

const props = defineProps({
  roleId: {
    type: [Number, String]
  }
})

const { proxy } = getCurrentInstance()
const { sys_normal_disable } = useDict("sys_normal_disable")

const userList = ref([])
const visible = ref(false)
const total = ref(0)
const userIds = ref([])

const queryParams = reactive({
  pageNum: 1,
  pageSize: 10,
  roleId: undefined,
  userName: undefined,
  phonenumber: undefined
})

function show() {
  queryParams.roleId = props.roleId
  getList()
  visible.value = true
}

function clickRow(row) {
  proxy.$refs["refTable"].toggleRowSelection(row)
}

function handleSelectionChange(selection) {
  userIds.value = selection.map(item => item.userId)
}

function getList() {
  unallocatedUserList(queryParams).then(res => {
    userList.value = res.rows
    total.value = res.total
  })
}

function handleQuery() {
  queryParams.pageNum = 1
  getList()
}

function resetQuery() {
  proxy.resetForm("queryRef")
  handleQuery()
}

const emit = defineEmits(["ok"])
function handleSelectUser() {
  const roleId = queryParams.roleId
  const uIds = userIds.value.join(",")
  if (uIds == "") {
    proxy.$modal.msgError(t('system.auth.selectUserRequired'))
    return
  }
  authUserSelectAll({ roleId: roleId, userIds: uIds }).then(res => {
    proxy.$modal.msgSuccess(res.msg)
    visible.value = false
    emit("ok")
  })
}

defineExpose({
  show,
})
</script>
