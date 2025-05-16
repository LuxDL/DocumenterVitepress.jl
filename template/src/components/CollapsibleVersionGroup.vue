<!-- CollapsibleVersionGroup.vue -->
<script setup lang="ts">
import { ref } from 'vue';

defineProps<{
  text: string;
  items: Array<{ text: string; link: string }>;
}>();

const isCollapsed = ref(true);

const toggleCollapse = () => {
  isCollapsed.value = !isCollapsed.value;
};
</script>

<template>
  <div class="collapsible-group">
    <div @click="toggleCollapse" class="group-header">
      <span class="group-title">{{ text }}</span>
      <span class="toggle-icon">{{ isCollapsed ? '+' : '-' }}</span>
    </div>
    <div v-if="!isCollapsed" class="group-items">
      <div v-for="item in items" :key="item.text" class="group-item">
        <a :href="item.link">{{ item.text }}</a>
      </div>
    </div>
  </div>
</template>

<style scoped>
.collapsible-group {
  margin: 4px 0;
}

.group-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  cursor: pointer;
  padding: 4px 16px;
  border-radius: 4px;
}

.group-header:hover {
  background-color: var(--vp-c-gray-light-4);
}

.toggle-icon {
  font-weight: bold;
  margin-left: 8px;
}

.group-items {
  padding-left: 16px;
}

.group-item {
  padding: 4px 16px;
}

.group-item a {
  color: var(--vp-c-text-2);
  text-decoration: none;
}

.group-item a:hover {
  color: var(--vp-c-brand);
}

/* Dark mode support */
html.dark .group-header:hover {
  background-color: var(--vp-c-gray-dark-3);
}
</style>