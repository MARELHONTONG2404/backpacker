<template>
  <el-dropdown trigger="click" @command="handleSetLanguage">
    <div class="lang-select right-menu-item hover-effect">
      <svg-icon icon-class="language" />
    </div>
    <template #dropdown>
      <el-dropdown-menu>
        <el-dropdown-item :disabled="language === 'id'" command="id">
          <span>Bahasa Indonesia</span>
        </el-dropdown-item>
        <el-dropdown-item :disabled="language === 'zh-cn'" command="zh-cn">
          <span>中文 (China)</span>
        </el-dropdown-item>
      </el-dropdown-menu>
    </template>
  </el-dropdown>
</template>

<script setup>
import { useI18n } from 'vue-i18n'

const { locale } = useI18n()
const language = ref(locale.value)

function handleSetLanguage(lang) {
  if (language.value === lang) return
  localStorage.setItem('locale', lang)
  locale.value = lang
  language.value = lang
  window.location.reload()
}
</script>

<style scoped>
.lang-select {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 100%;
  min-width: 36px;
  min-height: 36px;
  font-size: 18px;
  padding: 0 8px;
  cursor: pointer;
  -webkit-tap-highlight-color: transparent;
}
</style>
