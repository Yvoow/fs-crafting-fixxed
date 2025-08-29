<script setup>
import { ref, computed } from 'vue'
import Navbar from '../components/Navbar.vue'
import { useRouter } from 'vue-router'
import { getLocale } from '../utils/getLocale'
import { fetchData } from '../utils/fetchData'
import SmallBtn from '../components/utils/SmallBtn.vue'

const props = defineProps({
  config: Object,
  playerData: Object,
  items: Array,
  workbenchId: String,
})

const canAfford = (needed) => {
  return props.playerData && props.playerData.experience >= needed
}

const hasItem = (item, amount, itemName) => {
  if (!props.playerData || !Array.isArray(props.playerData.items)) return false
  const itemData = props.playerData.items.find(i => i && i.name && i.name === item)
  if (!itemData) return false
  return itemData.amount >= amount * (quantities.value[itemName] || 1)
}

const hasAllItems = (neededItems, item) => {
  return neededItems.every(needed =>
      hasItem(needed.item, needed.amount, item.item)
  ) 
}

const quantities = ref({})

const sanitizeAmount = (value) => {
  const onlyDigits = String(value ?? '').replace(/[^0-9]/g, '')
  const parsed = parseInt(onlyDigits, 10)
  if (isNaN(parsed) || parsed < 1) return 1
  return parsed
}

const onAmountInput = (event, item) => {
  const { value } = event.target
  const digitsOnly = String(value ?? '').replace(/[^0-9]/g, '')
  event.target.value = digitsOnly
  const safe = sanitizeAmount(digitsOnly)
  quantities.value[item.item] = safe
}

const onAmountBlur = (event, item) => {
  const safe = sanitizeAmount(event.target.value)
  quantities.value[item.item] = safe
  event.target.value = String(safe)
}

const startCrafting = (item) => {
  fetchData('startCrafting', {
    workbenchId: props.workbenchId,
    item: item,
    amount: quantities.value[item.item] || 1,
  })
}

const neededAmount = (originalAmount, itemName) => {
  return originalAmount * (quantities.value[itemName] || 1)
}
</script>
<template>
  <div class="flex flex-col gap-10 w-full">
    <Navbar
      :config="config"
      :player-data="playerData"
      :title="getLocale('title')"
      :items="[]"
    />

    <div class="grid grid-cols-[repeat(auto-fill,_minmax(250px,_1fr))] gap-5 overflow-auto">
      <div
        v-for="item in items"
        :key="item.title"
        class="bg-blocks rounded-[5px] p-5 relative flex flex-col"
      >
        <!-- Locked Overlay -->
        <div 
          v-if="!canAfford(item.experience?.needed)"
          class="absolute inset-0 bg-black/50 rounded-[5px] flex flex-col items-center justify-center z-10"
        >
          <div class="text-red-500 text-2xl mb-2">🔒</div>
          <p class="text-red-500 text-sm font-semibold text-center">Not enough experience</p>
          <p class="text-secondaryText text-xs text-center mt-1">Required: {{ item.experience?.needed }} XP</p>
        </div>

        <div class="flex w-full justify-between items-start">
          <div class="relative">
            <img :src="`nui://${config.imageDir}${item.item}.png`" alt="item" class=" w-16 h-16">
            <span 
              v-if="item.amount > 1"
              class="absolute -top-1 -right-1 bg-orange-500 text-white text-xs px-1.5 py-0.5 rounded-full font-semibold leading-none"
            >
              {{ item.amount }}x
            </span>
          </div>
          <span class="inline-flex text-secondaryText items-center justify-center bg-blocks2 rounded-[25px] px-2.5 py-1 text-[12px] leading-none">
            {{ item.experience?.needed }}
          </span>
        </div>

        <p class="mt-2.5 text-primaryText text-[14px] leading-none font-bold">
          {{ item.title }}
        </p>

        <div class="mt-5 grid grid-cols-3 gap-5 mr-[60px] flex-1">
          <div v-for="neededItem in item.neededItems" :key="neededItem.item" class=" text-secondaryText text-[14px] leading-none font-medium flex items-center gap-[5px]">
            <img :src="`nui://${config.imageDir}${neededItem.item}.png`" alt="item" class=" w-5 h-5">
            <span :class="{ 'text-red-500': !hasItem(neededItem.item, neededItem.amount, item.item) }">
              {{ neededAmount(neededItem.amount, item.item) }}x
            </span>
          </div>
        </div>

        <div class="mt-5 flex justify-end items-center gap-2">
          <input
            type="text"
            inputmode="numeric"
            pattern="[0-9]*"
            class="w-16 bg-blocks2 text-primaryText rounded-[5px] px-2 h-full text-sm outline-none text-center"
            :value="quantities[item.item] ?? 1"
            @input="onAmountInput($event, item)"
            @blur="onAmountBlur($event, item)"
          />
          <SmallBtn color="orange" @click="startCrafting(item)" />
        </div>

      </div>
    </div>
  </div>
</template>