<!-- Adapted from https://github.com/MakieOrg/Makie.jl/blob/master/docs/src/.vitepress/theme/VersionPicker.vue -->

<script setup lang="ts">
import { ref, onMounted, computed} from 'vue'
import { useData } from 'vitepress'
import VPNavBarMenuGroup from 'vitepress/dist/client/theme-default/components/VPNavBarMenuGroup.vue'
import VPNavScreenMenuGroup from 'vitepress/dist/client/theme-default/components/VPNavScreenMenuGroup.vue'

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
      )
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
    <VPNavBarMenuGroup
      v-if="!screenMenu && versions.length > 0"
      :item="{ text: currentVersion, items: versionItems }"
      class="VPVersionPicker"
    />
    <VPNavScreenMenuGroup
      v-else-if="screenMenu && versions.length > 0"
      :text="currentVersion"
      :items="versionItems"
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
</style>