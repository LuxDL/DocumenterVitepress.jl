<!-- Adapted from https://github.com/MakieOrg/Makie.jl/blob/master/docs/src/.vitepress/theme/VersionPicker.vue -->

<script setup lang="ts">
import { ref, onMounted, computed} from 'vue'
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

onMounted(() => {
  if (typeof window !== 'undefined') {
    currentVersion.value = window.DOCUMENTER_CURRENT_VERSION ?? 'Versions';
    loadVersions();
  }
});
</script>

<template>
  <template v-if="isClient">
    <!-- For Desktop Navigation -->
    <div v-if="!screenMenu && versions.length > 0" class="VPVersionPicker version-picker-container">
      <div class="version-menu-button" @click="$event.currentTarget.classList.toggle('expanded')">
        <span>{{ currentVersion }}</span>
        <span class="arrow" />
        
        <div class="dropdown-container">
          <template v-for="item in versionItems" :key="item.text">
            <!-- Standard direct link for standalone versions -->
            <a v-if="!item.items" :href="item.link" class="version-item">{{ item.text }}</a>
            
            <!-- Collapsible group for version groups -->
            <CollapsibleVersionGroup 
              v-else 
              :text="item.text" 
              :items="item.items" 
            />
          </template>
        </div>
      </div>
    </div>
    
    <!-- For Mobile Navigation -->
    <VPNavScreenMenuGroup
      v-else-if="screenMenu && versions.length > 0"
      :text="currentVersion"
      :items="versionItems"
      class="VPVersionPicker"
    >
      <template #item="{ item }">
        <!-- Handle collapsible groups in mobile view -->
        <CollapsibleVersionGroup 
          v-if="item.isCollapsible" 
          :text="item.text" 
          :items="item.items" 
        />
        <a v-else :href="item.link">{{ item.text }}</a>
      </template>
    </VPNavScreenMenuGroup>
  </template>
</template>

<style scoped>
.version-picker-container {
  position: relative;
  display: inline-block;
}

.version-menu-button {
  display: flex;
  align-items: center;
  cursor: pointer;
  padding: 0 12px;
  height: var(--vp-nav-height-mobile);
  color: var(--vp-c-text-1);
  transition: color 0.25s;
}

.version-menu-button:hover {
  color: var(--vp-c-brand);
}

.version-menu-button .arrow {
  margin-left: 4px;
  width: 6px;
  height: 6px;
  border-left: 1px solid currentColor;
  border-bottom: 1px solid currentColor;
  transform: rotate(-45deg);
  transition: transform 0.25s;
}

.version-menu-button.expanded .arrow {
  transform: rotate(135deg);
}

.dropdown-container {
  display: none;
  position: absolute;
  top: 100%;
  left: 0;
  min-width: 200px;
  background: var(--vp-c-bg);
  border: 1px solid var(--vp-c-divider);
  border-radius: 8px;
  padding: 8px 0;
  box-shadow: 0 6px 12px rgba(0, 0, 0, 0.1);
  z-index: 100;
}

.version-menu-button.expanded .dropdown-container {
  display: block;
}

.version-item {
  display: block;
  padding: 8px 16px;
  color: var(--vp-c-text-1);
  text-decoration: none;
}

.version-item:hover {
  background-color: var(--vp-c-gray-light-4);
  color: var(--vp-c-brand);
}

/* Dark mode overrides */
html.dark .version-item:hover {
  background-color: var(--vp-c-gray-dark-3);
}
</style>