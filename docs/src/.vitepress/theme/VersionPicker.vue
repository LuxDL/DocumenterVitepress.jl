<!-- From https://github.com/MakieOrg/Makie.jl/blob/master/docs/src/.vitepress/theme/VersionPicker.vue -->
<script setup lang="ts">
import { computed, ref, onMounted } from 'vue'
import { useRoute } from 'vitepress'
import VPNavBarMenuGroup from 'vitepress/dist/client/theme-default/components/VPNavBarMenuGroup.vue'
import VPNavScreenMenuGroup from 'vitepress/dist/client/theme-default/components/VPNavScreenMenuGroup.vue'

const props = defineProps<{
  screenMenu?: boolean
}>()

const route = useRoute()
const versions = ref([]);
const currentVersion = ref('Versions');

const waitForGlobalDocumenterVars = () => {
  return new Promise((resolve) => {
    const checkInterval = setInterval(() => {
      if (window.DOC_VERSIONS && window.DOCUMENTER_CURRENT_VERSION) {
        clearInterval(checkInterval);
        resolve({
          versions: window.DOC_VERSIONS,
          currentVersion: window.DOCUMENTER_CURRENT_VERSION
        });
      }
    }, 100); // Check every 100ms
  });
};

onMounted(async () => {
  try {
    const globalvars = await waitForGlobalDocumenterVars();
    versions.value = globalvars.versions.map((v) => {
      return {text: v, link: `${window.location.origin}/${v}/`}
    });
    currentVersion.value = globalvars.currentVersion;
  } catch (error) {
    console.error('Error setting up VersionPicker:', error);
    // Set default values if there's an error
    versions.value = [];
    currentVersion.value = 'Versions';
  }
});

// Computed property to ensure we always have a valid array
const safeVersions = computed(() => versions.value || [])
</script>

<template>
  <VPNavBarMenuGroup
    v-if="!screenMenu && safeVersions.length > 0"
    :item="{ text: currentVersion, items: safeVersions }"
    class="VPVersionPicker"
  />
  <VPNavScreenMenuGroup
    v-else-if="screenMenu && safeVersions.length > 0"
    :text="currentVersion"
    :items="safeVersions"
    class="VPVersionPicker"
  />
</template>

<style scoped>
.VPVersionPicker :deep(button .text) {
  color: var(--vp-c-text-1) !important;
}
.VPVersionPicker:hover :deep(button .text) {
  color: var(--vp-c-text-2) !important;
}
</style>