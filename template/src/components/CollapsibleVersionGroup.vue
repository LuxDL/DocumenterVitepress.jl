<!-- CollapsibleVersionGroup.vue -->
<script setup lang="ts">
import { ref } from 'vue';

defineProps<{
  text: string;
  items: Array<{ text: string; link: string }>;
}>();

const isCollapsed = ref(true);

const toggleCollapse = (event) => {
  // Stop event propagation to prevent parent menu from closing
  event.stopPropagation();
  isCollapsed.value = !isCollapsed.value;
};
</script>

<template>
  <div class="version-group">
    <div @click="toggleCollapse" class="version-group-header">
      <span class="version-group-title">{{ text }}</span>
      <span class="version-group-icon">{{ isCollapsed ? '+' : '-' }}</span>
    </div>
    <div v-if="!isCollapsed" class="version-group-items">
      <a 
        v-for="item in items" 
        :key="item.text" 
        :href="item.link" 
        class="version-item"
      >
        {{ item.text }}
      </a>
    </div>
  </div>
</template>

<style scoped>
.version-group {
  width: 100%;
}

.version-group-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 16px;
  height: 34px;
  margin: 0 -4px;
  cursor: pointer;
  color: var(--vp-c-text-1);
}

.version-group-header:hover {
  color: var(--vp-c-brand);
}

.version-group-icon {
  font-size: 12px;
  opacity: 0.75;
}

.version-group-items {
  padding: 0;
  margin: 0;
}

.version-item {
  display: block;
  padding: 0 24px;
  height: 32px;
  line-height: 32px;
  color: var(--vp-c-text-1);
  transition: color 0.25s;
  text-decoration: none;
}

.version-item:hover {
  color: var(--vp-c-brand);
}
</style>