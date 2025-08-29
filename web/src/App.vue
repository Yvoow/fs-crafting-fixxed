<script setup>
import { onBeforeMount, ref } from 'vue'
import { RouterView } from 'vue-router'
import { fetchData } from './utils/fetchData'
import { initLocales } from './utils/getLocale'
import { close } from './utils/close'

const config = ref({})
const playerData = ref({})
const items = ref([])
const workbenchId = ref('')

onBeforeMount(async () => {
  await initLocales()
  fetchData('fetchConfig').then((fetchedConfig) => {
    if (!fetchedConfig) return
    config.value = fetchedConfig
    if (config.value.ui.colors) {
      let colors = config.value.ui.colors
      setColors(colors)
    }
  })
})

const setColors = (colors) => {
  document.documentElement.style.setProperty('--primary', colors.primary || '#FF8563')
  document.documentElement.style.setProperty('--secondary', colors.secondary || '#2B89EF')
  document.documentElement.style.setProperty('--background', colors.background || '#111111')
  document.documentElement.style.setProperty('--blocks', colors.blocks || '#161616')
  document.documentElement.style.setProperty('--blocks2', colors.blocks2 || '#333333')
  document.documentElement.style.setProperty('--primaryText', colors.primaryText || '#FFFFFF')
  document.documentElement.style.setProperty('--secondaryText', colors.secondaryText || '#777777')
}

window.addEventListener('message', (event) => {
  if (event.data.type === 'open') {
    document.body.style.display = 'block'
    playerData.value = event.data.pData
    items.value = event.data.items
    workbenchId.value = event.data.workbenchId
  } else if (event.data.type === 'close') {
    document.body.style.display = 'none'
  }
})

window.addEventListener('keydown', (event) => {
  if (event.key === 'Escape') {
    close()
  }
})
</script>

<template>
  <div class="h-screen w-screen bg-black/70 flex justify-center items-center text-primaryText">
    <div class="flex w-[75vw] h-[80vh] bg-background p-10 rounded-[5px]">
      <RouterView
        :config="config"
        :player-data="playerData"
        :items="items"
        :workbench-id="workbenchId"
      />
    </div>
  </div>
</template>
