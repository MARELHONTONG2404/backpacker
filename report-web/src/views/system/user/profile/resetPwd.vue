<template>
  <el-form ref="pwdRef" :model="user" :rules="rules" label-width="140px">
    <el-form-item :label="t('system.profile.oldPassword')" prop="oldPassword">
      <el-input v-model="user.oldPassword" :placeholder="t('system.profile.oldPasswordPlaceholder')" type="password" show-password />
    </el-form-item>
    <el-form-item :label="t('system.profile.newPassword')" prop="newPassword" :rules="infoPwdValidator">
      <el-input v-model="user.newPassword" :placeholder="t('system.profile.newPasswordPlaceholder')" type="password" show-password />
    </el-form-item>
    <el-form-item :label="t('system.profile.confirmPassword')" prop="confirmPassword">
      <el-input v-model="user.confirmPassword" :placeholder="t('system.profile.confirmPasswordPlaceholder')" type="password" show-password />
    </el-form-item>
    <el-form-item>
      <el-button type="primary" @click="submit">{{ t('common.save') }}</el-button>
      <el-button type="danger" @click="close">{{ t('common.close') }}</el-button>
    </el-form-item>
  </el-form>
</template>

<script setup>
import { useI18n } from 'vue-i18n'
import { usePasswordRule } from "@/utils/passwordRule"
import { updateUserPwd } from "@/api/system/user"

const { t } = useI18n()
const { proxy } = getCurrentInstance()
const { infoPwdValidator } = usePasswordRule()

const user = reactive({
  oldPassword: undefined,
  newPassword: undefined,
  confirmPassword: undefined
})

const equalToPassword = (rule, value, callback) => {
  if (user.newPassword !== value) {
    callback(new Error(t('system.profile.passwordMismatch')))
  } else {
    callback()
  }
}

const rules = computed(() => ({
  oldPassword: [{ required: true, message: t('system.profile.oldPasswordRequired'), trigger: "blur" }],
  confirmPassword: [
    { required: true, message: t('system.profile.confirmPasswordRequired'), trigger: "blur" },
    { required: true, validator: equalToPassword, trigger: "blur" }
  ]
}))

function submit() {
  proxy.$refs.pwdRef.validate(valid => {
    if (valid) {
      updateUserPwd(user.oldPassword, user.newPassword).then(() => {
        proxy.$modal.msgSuccess(t('system.editSuccess'))
      })
    }
  })
}

function close() {
  proxy.$tab.closePage()
}
</script>
