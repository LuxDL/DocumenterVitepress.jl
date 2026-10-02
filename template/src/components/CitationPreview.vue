<template>
  <span
    ref="wrapperRef"
    class="dv-citation-wrapper"
    @mouseover="handleMouseOver"
    @mouseleave="handleMouseLeave"
    @focusin="handleMouseOver"
    @focusout="handleMouseLeave"
  >
    <slot />
    <Teleport to="body">
      <Transition name="dv-citation-fade">
        <div
          v-if="visible && previewContent"
          ref="popoverRef"
          class="dv-citation-popover"
          :style="popoverStyle"
          @mouseenter="clearHideTimer"
          @mouseleave="scheduleHide"
        >
          <div class="dv-citation-popover-content" v-html="previewContent"></div>
        </div>
      </Transition>
    </Teleport>
  </span>
</template>

<script setup>
import { ref, reactive, onMounted, onUnmounted } from 'vue'

const wrapperRef = ref(null)
const popoverRef = ref(null)
const visible = ref(false)
const previewContent = ref('')
const popoverStyle = reactive({
  top: '0px',
  left: '0px',
  maxWidth: '440px',
  transform: 'none',
})

let hideTimer = null
let showTimer = null

function cleanReferenceHtml(el) {
  if (!el) return ''
  const container = el.closest('li') || el.closest('dd') || el.parentElement
  if (!container) return ''
  const clone = container.cloneNode(true)
  // Remove backlink elements (pointing to cit-... or containing ↩)
  const backlinks = clone.querySelectorAll('a[href*="#cit-"], a[href^="#cit-"]')
  backlinks.forEach((bl) => bl.remove())
  // Remove anchor tag if empty
  const anchor = clone.querySelector('.dv-bib-anchor, a[id]')
  if (anchor && anchor.textContent.trim() === '') {
    anchor.remove()
  }
  return clone.innerHTML.trim()
}

function updatePosition(targetEl) {
  if (!targetEl) return
  const rect = targetEl.getBoundingClientRect()
  const popoverWidth = Math.min(440, window.innerWidth - 24)
  
  let left = rect.left + rect.width / 2 - popoverWidth / 2
  if (left < 12) left = 12
  if (left + popoverWidth > window.innerWidth - 12) {
    left = window.innerWidth - popoverWidth - 12
  }

  const spaceAbove = rect.top
  const popoverEstimatedHeight = 120
  let top = 0

  if (spaceAbove > popoverEstimatedHeight + 10) {
    top = rect.top - 8
    popoverStyle.transform = 'translateY(-100%)'
  } else {
    top = rect.bottom + 8
    popoverStyle.transform = 'none'
  }

  popoverStyle.left = `${left}px`
  popoverStyle.top = `${top}px`
  popoverStyle.maxWidth = `${popoverWidth}px`
}

function handleMouseOver(e) {
  const link = e.target.closest('a')
  if (!link) return
  const href = link.getAttribute('href')
  if (!href) return
  
  const hashIndex = href.indexOf('#')
  if (hashIndex === -1) return
  const targetId = decodeURIComponent(href.slice(hashIndex + 1))
  if (!targetId || targetId.startsWith('cit-')) return

  clearHideTimer()
  
  showTimer = setTimeout(() => {
    const targetEl = document.getElementById(targetId)
    if (!targetEl) return

    const html = cleanReferenceHtml(targetEl)
    if (!html) return

    previewContent.value = html
    updatePosition(link)
    visible.value = true
  }, 100)
}

function handleMouseLeave() {
  if (showTimer) clearTimeout(showTimer)
  scheduleHide()
}

function clearHideTimer() {
  if (hideTimer) {
    clearTimeout(hideTimer)
    hideTimer = null
  }
}

function scheduleHide() {
  clearHideTimer()
  hideTimer = setTimeout(() => {
    visible.value = false
    previewContent.value = ''
  }, 200)
}

function handleScrollOrResize() {
  if (visible.value) {
    visible.value = false
  }
}

onMounted(() => {
  window.addEventListener('scroll', handleScrollOrResize, { passive: true })
  window.addEventListener('resize', handleScrollOrResize, { passive: true })
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScrollOrResize)
  window.removeEventListener('resize', handleScrollOrResize)
  clearHideTimer()
  if (showTimer) clearTimeout(showTimer)
})
</script>

<style>
.dv-citation-wrapper {
  display: inline;
}

.dv-citation-popover {
  position: fixed;
  z-index: 1000;
  padding: 10px 14px;
  font-size: 0.85rem;
  line-height: 1.5;
  color: var(--vp-c-text-1);
  background-color: var(--vp-c-bg-elv);
  border: 1px solid var(--vp-c-divider);
  border-radius: 8px;
  box-shadow: var(--vp-shadow-3);
  pointer-events: auto;
  font-family: var(--vp-font-family-base);
  word-break: break-word;
}

.dv-citation-popover-content p {
  margin: 0;
  line-height: 1.5;
}

.dv-citation-popover-content a {
  color: var(--vp-c-brand-1);
  text-decoration: underline;
  text-underline-offset: 2px;
}

.dv-citation-fade-enter-active,
.dv-citation-fade-leave-active {
  transition: opacity 0.15s ease, transform 0.15s ease;
}

.dv-citation-fade-enter-from,
.dv-citation-fade-leave-to {
  opacity: 0;
}
</style>
