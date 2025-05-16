<!-- Adapted from https://github.com/MakieOrg/Makie.jl/blob/master/docs/src/.vitepress/theme/VersionPicker.vue -->

<script setup lang="ts">
import { ref, onMounted, computed, onBeforeUnmount } from 'vue'
import { useData } from 'vitepress'
import VPNavBarMenuGroup from 'vitepress/dist/client/theme-default/components/VPNavBarMenuGroup.vue'
import VPNavScreenMenuGroup from 'vitepress/dist/client/theme-default/components/VPNavScreenMenuGroup.vue'
import CollapsibleVersionGroup from './CollapsibleVersionGroup.vue'

declare global {
  interface Window {
    DOC_VERSIONS?: string[];
    DOCUMENTER_CURRENT_VERSION?: string;
  }
}

const absoluteRoot = __DEPLOY_ABSPATH__;
const absoluteOrigin = (typeof window === 'undefined' ? '' : window.location.origin) + absoluteRoot;

const props = defineProps<{ screenMenu?: boolean }>();
const versions = ref<Array<{ text: string, link: string, class?: string }>>([]);
const currentVersion = ref('Versions');
const isClient = ref(false);
const { site } = useData();
const isOpen = ref(false);

const isLocalBuild = () => {
  return typeof window !== 'undefined' && (window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1');
};

const waitForScriptsToLoad = () => {
  return new Promise<boolean>((resolve) => {
    if (isLocalBuild() || typeof window === 'undefined') {
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
      versions.value = [{ text: 'dev', link: '/' }];
      currentVersion.value = 'dev';
    } else {
      const scriptsLoaded = await waitForScriptsToLoad();

      if (scriptsLoaded && window.DOC_VERSIONS && window.DOCUMENTER_CURRENT_VERSION) {
        const allVersions = new Set([...window.DOC_VERSIONS, window.DOCUMENTER_CURRENT_VERSION]);
        versions.value = Array.from(allVersions).map(v => ({
          text: v,
          link: `${absoluteOrigin}/${v}/`
        }));
        currentVersion.value = window.DOCUMENTER_CURRENT_VERSION;
      } else {
        versions.value = [{ text: 'dev', link: `${absoluteOrigin}/dev/` }];
        currentVersion.value = 'dev';
      }
    }
  } catch (error) {
    console.warn('Error loading versions:', error);
    versions.value = [{ text: 'dev', link: `${absoluteOrigin}/dev/` }];
    currentVersion.value = 'dev';
  }
  isClient.value = true;
};

interface Version {
  text: string;
  link: string;
}

interface VersionGroup {
  text: string;
  items?: Version[];
  link?: string;
  isCollapsible?: boolean;
}

// Parse version string to extract major.minor part (e.g., "v0.1" from "v0.1.2")
const parseVersionString = (version: string): { groupKey: string; full: string } | null => {
  // Match patterns like v0.1.2 or 0.1.2
  const match = version.match(/^(v?)(\d+)\.(\d+)\.(\d+)$/);
  if (match) {
    const prefix = match[1]; // "v" or ""
    return {
      groupKey: `${prefix}${match[2]}.${match[3]}`, // e.g., "v0.1"
      full: version
    };
  }
  return null;
};

const versionItems = computed(() => {
  const groups = new Map<string, Version[]>();
  const standalone: VersionGroup[] = [];

  versions.value.forEach((v) => {
    const parsed = parseVersionString(v.text);
    
    if (!parsed) {
      // Handle special versions like 'dev' or 'stable'
      standalone.push({
        text: v.text,
        link: v.link
      });
      return;
    }

    // Create group if it doesn't exist
    if (!groups.has(parsed.groupKey)) {
      groups.set(parsed.groupKey, []);
    }

    // Add version to the appropriate group
    groups.get(parsed.groupKey)!.push({
      text: v.text,
      link: v.link
    });
  });

  // Create the final items array, starting with standalone items
  const items: VersionGroup[] = [...standalone];

  // Add grouped versions
  for (const [groupKey, versionsList] of groups) {
    items.push({
      text: groupKey, // e.g., "v0.1"
      items: versionsList.sort((a, b) =>
        b.text.localeCompare(a.text, undefined, { numeric: true })
      ),
      isCollapsible: true
    });
  }

  // Sort the groups themselves (excluding standalone items)
  items.sort((a, b) => {
    // Keep standalone items at the top
    if (!a.items) return -1;
    if (!b.items) return 1;
    
    // Sort other groups by version number (descending)
    return b.text.localeCompare(a.text, undefined, { numeric: true });
  });

  return items;
});

const toggleDropdown = (event) => {
  event.stopPropagation();
  isOpen.value = !isOpen.value;
};

const closeDropdown = () => {
  isOpen.value = false;
};

onMounted(() => {
  if (typeof window !== 'undefined') {
    currentVersion.value = window.DOCUMENTER_CURRENT_VERSION ?? 'Versions';
    loadVersions();
    
    // Add global click event to close dropdown when clicking outside
    document.addEventListener('click', closeDropdown);
  }
});

// Clean up event listener
onBeforeUnmount(() => {
  document.removeEventListener('click', closeDropdown);
});
</script>

<template>
  <template v-if="isClient">
    <!-- For Desktop Navigation -->
    <div v-if="!screenMenu && versions.length > 0" class="VPVersionPicker custom-version-picker">
      <button 
        type="button" 
        class="version-button" 
        role="button" 
        aria-haspopup="true"
        :aria-expanded="isOpen"
        @click="toggleDropdown"
      >
        <span class="button-text">{{ currentVersion }}</span>
        <span class="button-arrow" :class="{ 'is-open': isOpen }"></span>
      </button>
      
      <div v-if="isOpen" class="dropdown" @click.stop>
        <div class="dropdown-wrapper">
          <div class="dropdown-items">
            <!-- Regular links for standalone versions -->
            <a 
              v-for="item in versionItems.filter(i => !i.items)" 
              :key="item.text" 
              :href="item.link" 
              class="dropdown-item"
            >
              {{ item.text }}
            </a>
            
            <!-- Collapsible groups -->
            <CollapsibleVersionGroup 
              v-for="item in versionItems.filter(i => i.items)" 
              :key="item.text" 
              :text="item.text" 
              :items="item.items" 
            />
          </div>
        </div>
      </div>
    </div>
    
    <!-- For Mobile Navigation -->
    <VPNavScreenMenuGroup
      v-else-if="screenMenu && versions.length > 0"
      :text="currentVersion"
      :items="versionItems.filter(i => !i.isCollapsible)"
      class="VPVersionPicker mobile-version-picker"
    />
    
    <!-- For Mobile: Custom Group Implementation -->
    <div v-if="screenMenu && versions.length > 0" class="mobile-collapsible-wrapper">
      <CollapsibleVersionGroup 
        v-for="item in versionItems.filter(i => i.isCollapsible)" 
        :key="item.text" 
        :text="item.text" 
        :items="item.items" 
      />
    </div>
  </template>
</template>

<style scoped>
.custom-version-picker {
  position: relative;
  color: var(--vp-c-text-1);
}

.version-button {
  display: flex;
  align-items: center;
  height: var(--vp-nav-height-mobile);
  padding: 0 12px;
  margin: 0 -12px;
  background: transparent;
  border: none;
  color: var(--vp-c-text-1);
  transition: color 0.25s;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
}

.version-button:hover {
  color: var(--vp-c-brand);
}

.button-text {
  line-height: var(--vp-nav-height-mobile);
}

.button-arrow {
  margin-left: 4px;
  width: 7px;
  height: 7px;
  border-top: 1px solid currentColor;
  border-right: 1px solid currentColor;
  transform: rotate(135deg) translateY(-3px);
  transition: transform 0.25s;
}

.button-arrow.is-open {
  transform: rotate(-45deg) translateY(0);
}

.dropdown {
  position: absolute;
  top: calc(var(--vp-nav-height-mobile) - 1px);
  right: 0;
  overflow: hidden;
  border-radius: 8px;
  box-shadow: var(--vp-shadow-3);
  border: 1px solid var(--vp-c-divider);
  background-color: var(--vp-c-bg);
  min-width: 180px;
  z-index: 100;
}

.dropdown-wrapper {
  max-height: calc(100vh - var(--vp-nav-height-mobile) - 20px);
  overflow-y: auto;
}

.dropdown-items {
  padding: 12px 0;
}

.dropdown-item {
  display: block;
  padding: 0 16px;
  height: 32px;
  line-height: 32px;
  font-size: 14px;
  color: var(--vp-c-text-1);
  white-space: nowrap;
  text-decoration: none;
}

.dropdown-item:hover {
  color: var(--vp-c-brand);
}

.mobile-collapsible-wrapper {
  padding: 0 24px;
  margin-top: 12px;
}

/* Dark mode support */
html.dark .dropdown {
  background-color: var(--vp-c-bg);
}
</style>