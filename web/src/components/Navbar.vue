<script setup>
import { ref, computed } from 'vue'
import { RouterLink, useRouter } from 'vue-router'
import { close } from '../utils/close'
import { getLocale } from '../utils/getLocale'
 
const props = defineProps({
  config: Object,
  title: String,
  items: Array,
  playerData: Object,
})

const router = useRouter()

const currentRoute = computed(() => router.currentRoute.value.name)
const isActive = (route) => currentRoute.value === route
const title = computed(() => props.playerData.label || props.title)

</script>
<template>
  <div class="relative flex justify-between w-full items-center h-11">
    <div class="flex items-center gap-5">
      <img src="/img/icon.svg" alt="icon" class="w-10 h-10">
      <h1 class="text-[24px] leading-[32px] font-extrabold">{{ title || props.title }}</h1>
    </div>

    <div v-if="items.length > 0" class="absolute left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2 flex items-center h-11 p-0.5 bg-blocks rounded-[5px]">
      <RouterLink
        v-for="item in items"
        :key="item.id"
        :to="item.route"
        class="flex items-center px-[18px] rounded-[5px] h-full text-secondaryText hover:text-primaryText transition-all duration-300 text-[18px] leading-[16px] font-medium"
        :class="{ 'text-blocks bg-primary': isActive(item.route) }"
      >
        <p>{{ getLocale(item.name) }}</p>
      </RouterLink>
    </div>

    <div class="flex h-full items-center gap-5 justify-end">
      <div class="h-full p-1.5 bg-blocks rounded-[5px] flex flex-col justify-between">
        <h1 class="text-primaryText text-[14px] leading-none">
          {{ playerData.name }}
        </h1>
        <p class="text-secondaryText text-[10px] leading-none">
          Your experience: {{ playerData.experience }}
        </p>
      </div>

      <!-- close button -->
      <div class="p-2.5 bg-blocks rounded-full flex items-center justify-center group cursor-pointer" @click="close">
        <svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path class="fill-secondaryText group-hover:fill-primaryText" fill-rule="evenodd" clip-rule="evenodd" d="M0.487487 0.508814C0.799719 0.196362 1.22314 0.0208363 1.66464 0.0208363C2.10613 0.0208363 2.52955 0.196362 2.84178 0.508814L9.98959 7.66381L17.1374 0.508814C17.291 0.34963 17.4747 0.22266 17.6778 0.135311C17.881 0.0479631 18.0995 0.00198596 18.3205 6.29284e-05C18.5416 -0.0018601 18.7609 0.0403091 18.9655 0.124111C19.1701 0.207912 19.356 0.331667 19.5123 0.488155C19.6687 0.644643 19.7923 0.83073 19.876 1.03556C19.9597 1.24038 20.0019 1.45985 19.9999 1.68115C19.998 1.90245 19.9521 2.12115 19.8648 2.32449C19.7776 2.52783 19.6507 2.71174 19.4917 2.86548L12.3439 10.0205L19.4917 17.1755C19.795 17.4898 19.9628 17.9108 19.959 18.3478C19.9552 18.7848 19.7801 19.2028 19.4714 19.5118C19.1627 19.8209 18.7451 19.9961 18.3086 19.9999C17.872 20.0037 17.4514 19.8357 17.1374 19.5321L9.98959 12.3771L2.84178 19.5321C2.52776 19.8357 2.10718 20.0037 1.67063 19.9999C1.23407 19.9961 0.816472 19.8209 0.507769 19.5118C0.199066 19.2028 0.0239602 18.7848 0.0201666 18.3478C0.0163731 17.9108 0.184196 17.4898 0.487487 17.1755L7.63529 10.0205L0.487487 2.86548C0.175349 2.55293 0 2.12909 0 1.68715C0 1.24521 0.175349 0.82136 0.487487 0.508814Z"/>
        </svg>
      </div>
    </div>

  </div>
</template>