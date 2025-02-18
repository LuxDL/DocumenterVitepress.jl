<!-- Adapted from https://github.com/MakieOrg/Makie.jl/blob/master/docs/src/.vitepress/theme/VersionPicker.vue -->

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { useData } from 'vitepress'
import VPNavBarMenuGroup from 'vitepress/dist/client/theme-default/components/VPNavBarMenuGroup.vue'
import VPNavScreenMenuGroup from 'vitepress/dist/client/theme-default/components/VPNavScreenMenuGroup.vue'

// Extend the global Window interface to include DOC_VERSIONS and DOCUMENTER_CURRENT_VERSION
declare global {
  interface Window {
    DOC_VERSIONS?: string[];
    DOCUMENTER_CURRENT_VERSION?: string;
  }
}

const props = defineProps<{
  screenMenu?: boolean
}>()

const versions = ref<Array<{ text: string, link: string }>>([]);
const currentVersion = ref(window.DOCUMENTER_CURRENT_VERSION || 'Versions');
const isClient = ref(false);
const { site } = useData()

const isLocalBuild = () => {
  return typeof window !== 'undefined' && (window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1');
}

const getBaseRepository = () => {
  if (typeof window === 'undefined') return ''; // Handle server-side rendering (SSR)
  const { origin, pathname } = window.location;
  if (origin.includes('github.io')) {
    const pathParts = pathname.split('/').filter(Boolean);
    const baseRepo = pathParts.length > 0 ? `/${pathParts[0]}` : '';
    return `${origin}${baseRepo}`;
  } else {
    return origin;
  }
};

const waitForScriptsToLoad = () => {
  return new Promise<boolean>((resolve) => {
    if (isLocalBuild()) {
      resolve(false);
      return;
    }
    const checkInterval = setInterval(() => {
      if (window.DOC_VERSIONS && window.DOCUMENTER_CURRENT_VERSION) {
        clearInterval(checkInterval);
        resolve(true);
      }
    }, 100);
    setTimeout(() => {
      clearInterval(checkInterval);
      resolve(false);
    }, 5000);
  });
};

const loadVersions = async () => {
  if (typeof window === 'undefined') return;

  try {
    if (isLocalBuild()) {
      const fallbackVersions = ['dev'];
      versions.value = fallbackVersions.map(v => ({ text: v, link: '/' }));
      currentVersion.value = 'dev';
    } else {
      const scriptsLoaded = await waitForScriptsToLoad();
      const getBaseRepositoryPath = computed(() => getBaseRepository());

      if (scriptsLoaded && window.DOC_VERSIONS && window.DOCUMENTER_CURRENT_VERSION) {
        // Ensure the current version is included in the list
        const allVersions = new Set([...window.DOC_VERSIONS, window.DOCUMENTER_CURRENT_VERSION]);
        
        versions.value = Array.from(allVersions).map((v: string) => ({
          text: v,
          link: `${getBaseRepositoryPath.value}/${v}/`,
          class: v === window.DOCUMENTER_CURRENT_VERSION ? 'current-version' : ''
        }));
        currentVersion.value = window.DOCUMENTER_CURRENT_VERSION;
      } else {
        const fallbackVersions = ['dev'];
        versions.value = fallbackVersions.map(v => ({
          text: v,
          link: `${getBaseRepositoryPath.value}/${v}/`
        }));
        currentVersion.value = 'dev';
      }
    }
  } catch (error) {
    console.warn('Error loading versions:', error);
    const fallbackVersions = ['dev'];
    const getBaseRepositoryPath = computed(() => getBaseRepository());
    versions.value = fallbackVersions.map(v => ({
      text: v,
      link: `${getBaseRepositoryPath.value}/${v}/`
    }));
    currentVersion.value = 'dev';
  }
  isClient.value = true;
};

onMounted(loadVersions);
</script>

<template>
  <template v-if="isClient">
    <VPNavBarMenuGroup
      v-if="!screenMenu && versions.length > 0"
      :item="{ text: 'Version', items: versions.map(v => ({ text: v.text, link: v.link, class: v.text === currentVersion ? 'current-version' : '' })) }"
      class="VPVersionPicker"
    />
    <VPNavScreenMenuGroup
      v-else-if="screenMenu && versions.length > 0"
      :text="'Version'"
      :items="versions.map(v => ({ text: v.text, link: v.link, class: v.text === currentVersion ? 'current-version' : '' }))"
      class="VPVersionPicker"
    />
  </template>
</template>

<style scoped>
.VPVersionPicker :deep(button .text) {
  color: var(--vp-c-text-1) !important;
}
.VPVersionPicker:hover :deep(button .text) {
  color: var(--vp-c-text-2) !important;
}
.VPVersionPicker :deep(.current-version) {
  font-weight: bold;
  color: var(--vp-c-brand-1) !important;
}
</style>
