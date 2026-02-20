<script setup lang="ts">
import { ref, computed } from 'vue'

interface VersionEntry {
  text: string
  link: string
}

const props = defineProps<{
  currentVersion: string
  versions: VersionEntry[]
}>()

const isOpen = ref(false)
const expandedGroups = ref<Set<string>>(new Set())

// ── Semver helpers ────────────────────────────────────────────────────────────

function parseSemVer(v: string) {
  const match = v.match(/^v?(\d+)\.(\d+)(?:\.(\d+))?(.*)$/)
  if (!match) return null
  return {
    major: parseInt(match[1]),
    minor: parseInt(match[2]),
    patch: parseInt(match[3] ?? '0'),
    pre: match[4] ?? '',
  }
}

function groupKey(text: string): string | null {
  const parsed = parseSemVer(text)
  if (!parsed) return null
  return `v${parsed.major}.${parsed.minor}`
}

// ── Grouped structure ─────────────────────────────────────────────────────────

interface FlatItem {
  text: string
  link: string
  special?: boolean  // dev, stable, etc.
}

interface GroupHeader {
  key: string        // e.g. "v1.2"
  latestLink: string
  patches: FlatItem[]
}

type RowItem =
  | { kind: 'flat';   item: FlatItem }
  | { kind: 'group';  group: GroupHeader }
  | { kind: 'patch';  item: FlatItem; groupKey: string }

const rows = computed((): RowItem[] => {
  const special: FlatItem[] = []
  const grouped = new Map<string, FlatItem[]>()
  const groupOrder: string[] = []

  for (const v of props.versions) {
    const key = groupKey(v.text)
    if (!key) {
      special.push({ text: v.text, link: v.link, special: true })
    } else {
      if (!grouped.has(key)) {
        grouped.set(key, [])
        groupOrder.push(key)
      }
      grouped.get(key)!.push({ text: v.text, link: v.link })
    }
  }

  const result: RowItem[] = []

  for (const s of special) {
    result.push({ kind: 'flat', item: s })
  }

  for (const key of groupOrder) {
    const patches = grouped.get(key)!

    if (patches.length === 1) {
      // Single patch — show flat, no grouping needed
      result.push({ kind: 'flat', item: patches[0] })
    } else {
      result.push({
        kind: 'group',
        group: { key, latestLink: patches[0].link, patches },
      })
      if (expandedGroups.value.has(key)) {
        for (const p of patches) {
          result.push({ kind: 'patch', item: p, groupKey: key })
        }
      }
    }
  }

  return result
})

// ── Interactions ──────────────────────────────────────────────────────────────

function toggleDropdown() {
  isOpen.value = !isOpen.value
}

function toggleGroup(key: string, e: MouseEvent) {
  e.preventDefault()
  e.stopPropagation()
  const next = new Set(expandedGroups.value)
  if (next.has(key)) {
    next.delete(key)
  } else {
    next.add(key)
  }
  expandedGroups.value = next
}

function closeDropdown() {
  isOpen.value = false
}

// Auto-expand the group of the current version
function autoExpand() {
  const key = groupKey(props.currentVersion)
  if (key) {
    expandedGroups.value = new Set([key])
  }
}

defineExpose({ autoExpand })
</script>

<template>
  <div class="vp-version-dropdown" @keydown.escape="closeDropdown" @mouseenter="isOpen = true" @mouseleave="closeDropdown">
    <!-- Trigger button -->
    <button
      class="vp-version-trigger"
      :aria-expanded="isOpen"
      aria-haspopup="listbox"
      @click="toggleDropdown"
    >
      <span class="vp-version-trigger-text">{{ currentVersion }}</span>
      <span class="vp-version-trigger-chevron" :class="{ open: isOpen }">
        <svg width="12" height="12" viewBox="0 0 12 12" fill="none" aria-hidden="true">
          <path d="M2 4l4 4 4-4" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
      </span>
    </button>

    <!-- Dropdown panel -->
    <Transition name="vp-dropdown">
      <div
        v-if="isOpen"
        v-click-outside="closeDropdown"
        class="vp-version-panel"
        role="listbox"
      >
        <template v-for="row in rows" :key="row.kind === 'flat' ? row.item.text : row.kind === 'group' ? row.group.key : `${row.groupKey}::${row.item.text}`">

          <!-- Special / single-patch flat item -->
          <a
            v-if="row.kind === 'flat'"
            :href="row.item.link"
            class="vp-version-item"
            :class="{ 'is-current': row.item.text === currentVersion, 'is-special': row.item.special }"
            role="option"
            @click="closeDropdown"
          >
            {{ row.item.text }}
          </a>

          <!-- Group header row with +/× toggle -->
          <div
            v-else-if="row.kind === 'group'"
            class="vp-version-group-header"
            :class="{ 'is-expanded': expandedGroups.has(row.group.key) }"
          >
            <button
              class="vp-version-group-toggle"
              :aria-label="`${expandedGroups.has(row.group.key) ? 'Collapse' : 'Expand'} ${row.group.key}`"
              @click="(e) => toggleGroup(row.group.key, e)"
            >
              <span class="vp-toggle-icon">{{ expandedGroups.has(row.group.key) ? '×' : '+' }}</span>
            </button>
            <a
              :href="row.group.latestLink"
              class="vp-version-group-label"
              @click="closeDropdown"
            >
              {{ row.group.key }}
              <span class="vp-group-count">({{ row.group.patches.length }})</span>
            </a>
          </div>

          <!-- Expanded patch rows -->
          <a
            v-else-if="row.kind === 'patch'"
            :href="row.item.link"
            class="vp-version-item vp-version-patch"
            :class="{ 'is-current': row.item.text === currentVersion }"
            role="option"
            @click="closeDropdown"
          >
            {{ row.item.text }}
          </a>

        </template>
      </div>
    </Transition>
  </div>
</template>

<style scoped>
/* ── Container ── */
.vp-version-dropdown {
  position: relative;
  display: inline-flex;
  align-items: center;
}

/* ── Trigger button ── */
.vp-version-trigger {
  display: inline-flex;
  align-items: center;
  gap: 5px;
  padding: 0 12px;
  height: var(--vp-nav-height, 64px);
  background: transparent;
  border: none;
  cursor: pointer;
  font-family: inherit;
  font-size: 14px;
  font-weight: 500;
  color: var(--vp-c-text-1);
  transition: color 0.2s;
  white-space: nowrap;
}

.vp-version-trigger:hover {
  color: var(--vp-c-text-2);
}

.vp-version-trigger-chevron {
  display: flex;
  align-items: center;
  color: var(--vp-c-text-3);
  transition: transform 0.2s ease;
}

.vp-version-trigger-chevron.open {
  transform: rotate(180deg);
}

/* ── Dropdown panel ── */
.vp-version-panel {
  position: absolute;
  top: calc(100% - 12px);
  right: 0;
  min-width: 160px;
  font-family: inherit;
  background: var(--vp-c-bg-elv);
  border: 1px solid var(--vp-c-divider);
  border-radius: 8px;
  box-shadow: var(--vp-shadow-3);
  overflow: hidden;
  z-index: 100;
  padding: 4px 0;
}

/* ── Flat version item ── */
.vp-version-item {
  display: block;
  padding: 6px 14px;
  font-size: 13px;
  color: var(--vp-c-text-2);
  text-decoration: none;
  transition: background 0.15s, color 0.15s;
  white-space: nowrap;
}

.vp-version-item:hover {
  background: var(--vp-c-brand-soft);
  color: var(--vp-c-brand-1);
}

.vp-version-item.is-current {
  color: var(--vp-c-brand-1);
  font-weight: 600;
}

.vp-version-item.is-special {
  color: var(--vp-c-text-1);
}

/* ── Group header row ── */
.vp-version-group-header {
  display: flex;
  align-items: center;
  gap: 0;
  padding: 2px 0;
  border-top: 1px solid var(--vp-c-divider);
}

.vp-version-group-header:first-child {
  border-top: none;
}

.vp-version-group-toggle {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 28px;
  height: 28px;
  flex-shrink: 0;
  background: transparent;
  border: none;
  cursor: pointer;
  color: var(--vp-c-text-3);
  font-size: 14px;
  line-height: 1;
  transition: color 0.15s, background 0.15s;
  border-radius: 4px;
  margin-left: 4px;
}

.vp-version-group-toggle:hover {
  color: var(--vp-c-brand-1);
  background: var(--vp-c-default-soft);
}

.vp-toggle-icon {
  font-family: monospace;
  font-size: 15px;
  line-height: 1;
  user-select: none;
}

.vp-version-group-label {
  flex: 1;
  padding: 6px 10px 6px 4px;
  font-size: 13px;
  font-weight: 600;
  color: var(--vp-c-text-1);
  text-decoration: none;
  display: flex;
  align-items: center;
  gap: 5px;
  transition: color 0.15s;
}

.vp-version-group-label:hover {
  color: var(--vp-c-brand-1);
}

.vp-group-count {
  font-size: 11px;
  font-weight: 400;
  color: var(--vp-c-text-3);
}

/* ── Expanded patch items ── */
.vp-version-patch {
  padding-left: 36px;
  font-size: 12.5px;
  color: var(--vp-c-text-3);
  border-top: none;
}

.vp-version-patch:hover {
  background: var(--vp-c-brand-soft);
  color: var(--vp-c-brand-1);
}

.vp-version-patch.is-current {
  color: var(--vp-c-brand-1);
  font-weight: 600;
}

/* ── Transition ── */
.vp-dropdown-enter-active,
.vp-dropdown-leave-active {
  transition: opacity 0.15s ease, transform 0.15s ease;
}

.vp-dropdown-enter-from,
.vp-dropdown-leave-to {
  opacity: 0;
  transform: translateY(-4px);
}
</style>