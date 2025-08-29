<script setup lang="ts">

const props = defineProps<{
  color: 'orange' | 'blue'
}>()
</script>

<template>
  <button class="rounded-[5px] border border-blocks2 hover:border-transparent cursor-pointer w-12 h-12 flex justify-center items-center group transition-all duration-300" :class="color === 'orange' ? 'hover:bg-primary' : 'hover:bg-secondary'">
    <svg class="group-hover:rotate-90 transition-transform duration-300" width="13" height="13" viewBox="0 0 13 13" fill="none" xmlns="http://www.w3.org/2000/svg">
      <path class="group-hover:fill-background transition-all duration-300" d="M12.3566 1.3934C12.3566 0.979184 12.0208 0.643398 11.6066 0.643398L4.8566 0.643398C4.44239 0.643398 4.1066 0.979184 4.1066 1.3934C4.1066 1.80761 4.44239 2.1434 4.8566 2.1434H10.8566V8.1434C10.8566 8.55761 11.1924 8.8934 11.6066 8.8934C12.0208 8.8934 12.3566 8.55761 12.3566 8.1434L12.3566 1.3934ZM1 12L1.53033 12.5303L12.1369 1.92373L11.6066 1.3934L11.0763 0.863068L0.46967 11.4697L1 12Z" fill="#777777"/>
    </svg>
  </button>
</template>
