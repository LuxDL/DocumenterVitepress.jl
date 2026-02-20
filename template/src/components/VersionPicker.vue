<!-- Adapted from https://github.com/MakieOrg/Makie.jl/blob/master/docs/src/.vitepress/theme/VersionPicker.vue -->
<script setup lang="ts">
import { ref, onMounted, watch } from 'vue'
import VersionDropdown from './VersionDropdown.vue'

declare global {
  interface Window {
    DOC_VERSIONS?: string[];
    DOCUMENTER_CURRENT_VERSION?: string;
  }
}

// from vitepress, MIT
function joinPath(base: string, path: string) {
  return `${base}${path}`.replace(/\/+/g, '/')
}

const absoluteRoot = __DEPLOY_ABSPATH__
const siteOrigin = (typeof window === 'undefined' ? '' : window.location.origin)

function absoluteUrl(relative: string) {
  const withRoot = joinPath(absoluteRoot, relative)
  return siteOrigin + withRoot
}

const props = defineProps<{ screenMenu?: boolean }>()

const versions = ref<Array<{ text: string; link: string }>>([])
const currentVersion = ref('Versions')
const isClient = ref(false)
const dropdownRef = ref<InstanceType<typeof VersionDropdown> | null>(null)

const isLocalBuild = () =>
  typeof window !== 'undefined' &&
  (window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1')

const waitForScriptsToLoad = () =>
  new Promise<boolean>((resolve) => {
    if (isLocalBuild() || typeof window === 'undefined') {
      resolve(false)
      return
    }
    const checkInterval = setInterval(() => {
      if (window.DOC_VERSIONS && window.DOCUMENTER_CURRENT_VERSION) {
        clearInterval(checkInterval)
        resolve(true)
      }
    }, 100)
    setTimeout(() => {
      clearInterval(checkInterval)
      resolve(false)
    }, 5000)
  })

const loadVersions = async () => {
  if (typeof window === 'undefined') return
  try {
    if (isLocalBuild()) {
      versions.value = [{ text: 'dev', link: '/' }]
      currentVersion.value = 'dev'
    } else {
      const scriptsLoaded = await waitForScriptsToLoad()
      if (scriptsLoaded && window.DOC_VERSIONS && window.DOCUMENTER_CURRENT_VERSION) {
        versions.value = window.DOC_VERSIONS.map(v => ({
          text: v,
          link: absoluteUrl(`/${v}/`),
        }))
        currentVersion.value = window.DOCUMENTER_CURRENT_VERSION
      } else {
        versions.value = [{ text: 'dev', link: absoluteUrl('/dev/') }]
        currentVersion.value = 'dev'
      }
    }
  } catch (error) {
    console.warn('Error loading versions:', error)
    versions.value = [{ text: 'dev', link: absoluteUrl('/dev/') }]
    currentVersion.value = 'dev'
  }
  isClient.value = true
}

onMounted(() => {
  if (typeof window !== 'undefined') {
    currentVersion.value = window.DOCUMENTER_CURRENT_VERSION ?? 'Versions'
    loadVersions().then(() => {
      // Auto-expand the group containing the current version
      dropdownRef.value?.autoExpand()
    })
  }
})
</script>

<template>
  <template v-if="isClient && versions.length > 0">
    <VersionDropdown
      ref="dropdownRef"
      :current-version="currentVersion"
      :versions="versions"
      :class="screenMenu ? 'vp-version-screen' : 'vp-version-navbar'"
    />
  </template>
</template>

<style scoped>
/* Navbar mode: align with VitePress nav items */
.vp-version-navbar {
  display: flex;
  align-items: center;
}

/* Screen/mobile mode: full-width feel */
.vp-version-screen {
  width: 100%;
}

.vp-version-screen :deep(.vp-version-trigger) {
  width: 100%;
  justify-content: space-between;
  padding: 12px 16px;
  height: auto;
  border-bottom: 1px solid var(--vp-c-divider);
}

.vp-version-screen :deep(.vp-version-panel) {
  position: static;
  border: none;
  border-radius: 0;
  box-shadow: none;
  border-bottom: 1px solid var(--vp-c-divider);
}
</style>