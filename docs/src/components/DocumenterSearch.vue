<template>
  <div class="VPNavBarSearch">
    <div class="DocSearch-Button" @click="isOpen = true" aria-label="Search">
      <span class="DocSearch-Button-Container">
        <svg class="DocSearch-Search-Icon" width="20" height="20" viewBox="0 0 20 20" aria-label="search icon">
          <path d="M14.386 14.386l4.0877 4.0877-4.0877-4.0877c-2.9418 2.9419-7.7115 2.9419-10.6533 0-2.9419-2.9418-2.9419-7.7115 0-10.6533 2.9418-2.9419 7.7115-2.9419 10.6533 0 2.9419 2.9418 2.9419 7.7115 0 10.6533z" stroke="currentColor" fill="none" fill-rule="evenodd" stroke-linecap="round" stroke-linejoin="round"></path>
        </svg>
        <span class="DocSearch-Button-Placeholder">Search</span>
      </span>
      <span class="DocSearch-Button-Keys">
        <kbd class="DocSearch-Button-Key">⌘</kbd>
        <kbd class="DocSearch-Button-Key">K</kbd>
      </span>
    </div>

    <!-- Search Modal -->
    <Teleport to="body">
      <div v-if="isOpen" class="custom-search-modal" @click.self="isOpen = false">
        <div class="custom-search-modal-content">
          <!-- Header (Search Input) -->
          <div class="custom-search-header">
            <svg width="20" height="20" viewBox="0 0 20 20"><path d="M14.386 14.386l4.0877 4.0877-4.0877-4.0877c-2.9418 2.9419-7.7115 2.9419-10.6533 0-2.9419-2.9418-2.9419-7.7115 0-10.6533 2.9418-2.9419 7.7115-2.9419 10.6533 0 2.9419 2.9418 2.9419 7.7115 0 10.6533z" stroke="currentColor" fill="none" fill-rule="evenodd" stroke-linecap="round" stroke-linejoin="round"></path></svg>
            <input 
              ref="searchInputRef"
              v-model="searchQuery" 
              class="documenter-search-input" 
              placeholder="Search docs" 
              @input="onInput"
              @keydown.esc="isOpen = false"
            />
            <button class="close-btn" @click="isOpen = false">Esc</button>
          </div>

          <!-- Body (Filters and Results) -->
          <div class="search-modal-card-body">
            
            <div v-if="searchQuery.trim() === ''" class="has-text-centered my-5 py-5">
              Type something to get started!
            </div>
            
            <div v-else>
              <!-- Filters -->
              <div class="is-flex gap-2 is-flex-wrap-wrap is-justify-content-flex-start is-align-items-center search-filters">
                <span class="is-size-6" style="margin-right: 12px; font-weight: bold;">Filters:</span>
                <button 
                  class="search-filter"
                  :class="{ 'search-filter-selected': selectedFilter === '' }"
                  @click="toggleFilter('')"
                >
                  All <span class="filter-badge">{{ unfilteredResults.length }}</span>
                </button>
                <button 
                  v-for="filter in availableFilters" 
                  :key="filter"
                  class="search-filter"
                  :class="{ 'search-filter-selected': selectedFilter === filter.toLowerCase() }"
                  @click="toggleFilter(filter.toLowerCase())"
                >
                  {{ filter }} <span class="filter-badge">{{ categoryCounts[filter.toLowerCase()] || 0 }}</span>
                </button>
              </div>
              
              <div class="search-divider"></div>
              
              <!-- Result Count -->
              <div class="is-size-6 result-count">
                {{ filteredResults.length >= 200 ? '200+ results' : filteredResults.length + ' result(s)' }}
              </div>

              <!-- Results -->
              <div v-if="filteredResults.length === 0" class="has-text-centered my-5 py-5">
                No result found!
              </div>

              <div v-else class="is-clipped w-100 is-flex is-flex-direction-column gap-2 is-align-items-flex-start has-text-justified mt-1" @click="handleResultClick">
                <div v-for="result in filteredResults" :key="result.location" v-html="result.div"></div>
              </div>
            </div>
            
          </div>
        </div>
      </div>
    </Teleport>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted, watch, nextTick } from 'vue';

const isOpen = ref(false);
const searchQuery = ref('');
const searchInputRef = ref(null);
const selectedFilter = ref('');
const availableFilters = ref([]);
const unfilteredResults = ref([]);
const isWorkerRunning = ref(false);
let lastSearchText = '';
let worker = null;

// The filtered results computed on the frontend
const filteredResults = computed(() => {
  let results = unfilteredResults.value;
  if (selectedFilter.value) {
    results = results.filter(r => r.category.toLowerCase() === selectedFilter.value);
  }
  
  let final_results = [];
  let links = new Set();
  
  for (let i = 0; i < results.length && final_results.length < 200; ++i) {
    let res = results[i];
    if (res.location && !links.has(res.location)) {
      final_results.push(res);
      links.add(res.location);
    }
  }
  return final_results;
});

// Calculate counts per category based on current unfiltered results
const categoryCounts = computed(() => {
  const counts = {};
  for (const result of unfilteredResults.value) {
    const cat = result.category.toLowerCase();
    counts[cat] = (counts[cat] || 0) + 1;
  }
  return counts;
});

// Watch for modal open to focus input and attach global listener
watch(isOpen, (newVal) => {
  if (newVal) {
    nextTick(() => {
      searchInputRef.value?.focus();
    });
  }
});

// Toggle a filter
function toggleFilter(filter) {
  if (filter === '') {
    selectedFilter.value = '';
    return;
  }
  if (selectedFilter.value === filter) {
    selectedFilter.value = '';
  } else {
    selectedFilter.value = filter;
  }
}

// Close modal when clicking a result link
function handleResultClick(e) {
  if (e.target.closest('.search-result-link')) {
    isOpen.value = false;
  }
}

// Global hotkey (Cmd+K / Ctrl+K)
function handleGlobalKeydown(e) {
  if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
    e.preventDefault();
    isOpen.value = true;
  }
}

onMounted(() => {
  document.addEventListener('keydown', handleGlobalKeydown);
  initWorker();
});

onUnmounted(() => {
  document.removeEventListener('keydown', handleGlobalKeydown);
  if (worker) {
    worker.terminate();
  }
});

function launchSearch() {
  if (worker && searchQuery.value.trim() !== '') {
    isWorkerRunning.value = true;
    lastSearchText = searchQuery.value;
    worker.postMessage(lastSearchText);
  } else {
    unfilteredResults.value = [];
  }
}

function onInput() {
  if (!isWorkerRunning.value) {
    launchSearch();
  }
}

function initWorker() {
  const checkInterval = setInterval(() => {
    if (typeof window.documenterSearchIndex !== 'undefined') {
      clearInterval(checkInterval);
      
      const index = window.documenterSearchIndex;
      // Extract unique categories
      const categories = [...new Set(index.map(x => x.category))];
      availableFilters.value = categories;
      
      // We safely try to get deploy base URL from __DEPLOY_ABSPATH__ if defined, otherwise empty string
      let baseURL = '';
      try {
        baseURL = __DEPLOY_ABSPATH__ || '';
      } catch(e) {}
      
      const workerFunction = `
        function worker_function(documenterSearchIndex, documenterBaseURL, filters) {
          importScripts("https://cdn.jsdelivr.net/npm/minisearch@6.1.0/dist/umd/index.min.js");

          let data = documenterSearchIndex.map((x, key) => {
            x["id"] = key;
            return x;
          });

          const stopWords = new Set(["a","able","about","across","after","almost","also","am","among","an","and","are","as","at","be","because","been","but","by","can","cannot","could","dear","did","does","either","ever","every","from","got","had","has","have","he","her","hers","him","his","how","however","i","if","into","it","its","just","least","like","likely","may","me","might","most","must","my","neither","no","nor","not","of","off","often","on","or","other","our","own","rather","said","say","says","she","should","since","so","some","than","that","the","their","them","then","there","these","they","this","tis","to","too","twas","us","wants","was","we","were","what","when","who","whom","why","will","would","yet","you","your"]);

          const juliaTermPattern = /@(?:[\\p{L}_][\\p{L}\\p{M}\\p{N}_]*[!?]?)?|[\\p{L}_][\\p{L}\\p{M}\\p{N}_]*[!?]?|\\p{N}+(?:\\.\\p{N}+)?|(?<![\\p{L}\\p{M}\\p{N}_])(?:[+\\-*\\/\\\\^%<>=!&|~?:.]+|\\p{Sm}+)(?![\\p{L}\\p{M}\\p{N}_])/gu;

          let index = new MiniSearch({
            fields: ["title", "text"],
            storeFields: ["location", "title", "text", "category", "page"],
            processTerm: (term) => {
              if (typeof term !== "string") return null;
              const normalized = term.toLowerCase();
              return stopWords.has(normalized) ? null : normalized;
            },
            tokenize: (string) => {
              if (typeof string !== "string") return [];
              return string.match(juliaTermPattern) ?? [];
            },
            searchOptions: { 
              prefix: true, 
              boost: { title: 100 }, 
              fuzzy: (term) => (term.length >= 5 ? 0.2 : false) 
            },
          });

          index.addAll(data);

          const htmlEscapes = { "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" };
          const reUnescapedHtml = /[&<>"']/g;
          const reHasUnescapedHtml = RegExp(reUnescapedHtml.source);

          function escape(string) {
            return string && reHasUnescapedHtml.test(string)
              ? string.replace(reUnescapedHtml, (chr) => htmlEscapes[chr])
              : string || "";
          }

          function escapeRegExp(string) {
            return string.replace(/[.*+?^\${}()|[\\]\\\\]/g, "\\\\$&");
          }

          function make_search_result(result, querystring) {
            let search_divider = '<div class="search-divider w-100"></div>';
            let display_link = result.location.slice(0, 50) + (result.location.length > 50 ? "..." : "");
            if (result.page) {
              display_link += " (" + result.page + ")";
            }

            let searchstring = escapeRegExp(querystring);
            let textindex = new RegExp(searchstring, "i").exec(result.text || "");
            let text = textindex !== null
              ? result.text.slice(Math.max(textindex.index - 100, 0), Math.min(textindex.index + querystring.length + 100, (result.text || "").length))
              : ""; 

            text = text.length ? escape(text) : "";
            let display_result = text.length
              ? "..." + text.replace(new RegExp(escape(searchstring), "i"), '<span class="search-result-highlight">$&</span>') + "..."
              : "";

            let in_code = !["page", "section"].includes(result.category.toLowerCase());
            let titleClass = in_code ? "search-result-code-title" : "";
            
            // Adjust base URL path handling
            let finalUrl = documenterBaseURL + (documenterBaseURL.endsWith('/') || result.location.startsWith('/') ? '' : '/') + result.location;
            finalUrl = finalUrl.replace(/\\/\\//g, '/').replace('http:/', 'http://').replace('https:/', 'https://');

            return \`
              <a href="\${encodeURI(finalUrl)}" class="search-result-link px-4 py-2">
                <div class="search-result-header">
                  <div class="search-result-title \${titleClass}">\${escape(result.title)}</div>
                  <div class="property-search-result-badge">\${result.category}</div>
                </div>
                <p class="search-result-body">\${display_result}</p>
                <div class="search-result-loc" title="\${result.location}">
                  \${display_link}
                </div>
              </a>
              \${search_divider}
            \`;
          }

          self.onmessage = function (e) {
            let query = e.data;
            let results = index.search(query, {
              combineWith: "AND",
            });

            let filtered_results = [];
            let counts = {};
            for (let filter of filters) counts[filter] = 0;
            let present = {};

            for (let result of results) {
              let cat = result.category;
              let cnt = counts[cat] || 0;
              if (cnt < 200) {
                let id = cat + "---" + result.location;
                if (!present[id]) {
                  present[id] = true;
                  counts[cat] = cnt + 1;
                  filtered_results.push({
                    location: result.location,
                    category: cat,
                    div: make_search_result(result, query),
                  });
                }
              }
            }
            postMessage(filtered_results);
          };
        }
      `;
      
      const workerStr = `(${workerFunction})(${JSON.stringify(index)}, ${JSON.stringify(baseURL)}, ${JSON.stringify(categories)})`;
      const workerBlob = new Blob([workerStr], { type: "text/javascript" });
      worker = new Worker(URL.createObjectURL(workerBlob));
      
      worker.onmessage = (e) => {
        if (lastSearchText !== searchQuery.value) {
          launchSearch();
        } else {
          isWorkerRunning.value = false;
        }
        unfilteredResults.value = e.data;
      };
    }
  }, 1000);
}
</script>

<style scoped>
/* 
  VitePress Search Button Styling 
  Attempts to match VPNavBarSearch default styles
*/
.VPNavBarSearch {
  display: flex;
  align-items: center;
}
.DocSearch-Button {
  display: flex;
  justify-content: center;
  align-items: center;
  margin: 0;
  padding: 0 10px 0 12px;
  width: 100%;
  height: 40px;
  background: var(--vp-c-bg-alt);
  border-radius: 8px;
  color: var(--vp-c-text-2);
  border: 1px solid transparent;
  cursor: pointer;
  transition: border-color 0.25s, background-color 0.25s;
}
.DocSearch-Button:hover {
  background: transparent;
  border-color: var(--vp-c-brand-1);
}
.DocSearch-Button-Container {
  display: flex;
  align-items: center;
}
.DocSearch-Search-Icon {
  width: 16px;
  height: 16px;
  margin-right: 8px;
}
.DocSearch-Button-Placeholder {
  font-size: 13px;
  font-weight: 500;
}
.DocSearch-Button-Keys {
  display: flex;
  margin-left: 16px;
  min-width: calc(40px + 0.2em);
}
.DocSearch-Button-Key {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 22px;
  height: 22px;
  margin-right: 4px;
  border-radius: 4px;
  background-color: var(--vp-c-bg);
  border: 1px solid var(--vp-c-divider);
  box-shadow: 0 1px 1px rgba(0,0,0,0.1);
  font-size: 12px;
  font-family: var(--vp-font-family-base);
}

/* Modal Styling */
.custom-search-modal {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  background: rgba(0, 0, 0, 0.6);
  z-index: 1000;
  display: flex;
  justify-content: center;
  align-items: flex-start;
  padding-top: 10vh;
  backdrop-filter: blur(4px);
}

.custom-search-modal-content {
  background: var(--vp-c-bg);
  width: 90%;
  max-width: 700px;
  border-radius: 12px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
  overflow: hidden;
  display: flex;
  flex-direction: column;
  max-height: 80vh;
}

.custom-search-header {
  padding: 16px 20px;
  border-bottom: 1px solid var(--vp-c-divider);
  display: flex;
  align-items: center;
  gap: 12px;
}

.documenter-search-input {
  flex-grow: 1;
  background: transparent;
  border: none;
  outline: none;
  font-size: 1.1rem;
  color: var(--vp-c-text-1);
}

.close-btn {
  background: var(--vp-c-bg-alt);
  border: 1px solid var(--vp-c-divider);
  padding: 4px 8px;
  border-radius: 6px;
  font-size: 0.8rem;
  color: var(--vp-c-text-2);
  cursor: pointer;
}

.search-modal-card-body {
  padding: 20px;
  overflow-y: auto;
}

/* Filters */
.search-filters {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin-bottom: 12px;
  align-items: center;
}

.search-filter {
  background: var(--vp-c-bg-alt);
  border: 1px solid var(--vp-c-divider);
  padding: 4px 10px;
  border-radius: 16px;
  font-size: 0.85rem;
  cursor: pointer;
  color: var(--vp-c-text-2);
  transition: all 0.2s;
}

.search-filter:hover {
  border-color: var(--vp-c-brand-1);
  color: var(--vp-c-brand-1);
}

.search-filter-selected {
  background: var(--vp-c-brand-1);
  color: white;
  border-color: var(--vp-c-brand-1);
}
.search-filter-selected:hover {
  color: white;
}

.filter-badge {
  background: var(--vp-c-bg);
  color: var(--vp-c-text-2);
  padding: 1px 6px;
  border-radius: 10px;
  font-size: 0.7rem;
  margin-left: 4px;
}
.search-filter-selected .filter-badge {
  background: var(--vp-c-brand-soft);
  color: var(--vp-c-brand-1);
}

.search-divider {
  height: 1px;
  background: var(--vp-c-divider);
  margin: 12px 0;
}

.result-count {
  margin-bottom: 16px;
  color: var(--vp-c-text-2);
}

/* Results */
:deep(.search-result-link) {
  display: block;
  text-decoration: none !important;
  padding: 12px;
  border-radius: 8px;
  transition: background 0.2s;
  color: inherit;
}
:deep(.search-result-link:hover) {
  background: var(--vp-c-bg-alt);
}

:deep(.search-result-header) {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 4px;
}

:deep(.search-result-title) {
  font-weight: 600;
  color: var(--vp-c-brand-1);
}

:deep(.search-result-code-title) {
  font-family: monospace;
}

:deep(.property-search-result-badge) {
  font-size: 0.7rem;
  background: var(--vp-c-brand-soft);
  color: var(--vp-c-brand-1);
  padding: 2px 6px;
  border-radius: 4px;
  text-transform: uppercase;
}

:deep(.search-result-body) {
  font-size: 0.9rem;
  color: var(--vp-c-text-2);
  margin: 4px 0;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

:deep(.search-result-highlight) {
  background: rgba(255, 200, 0, 0.3);
  color: inherit;
  font-weight: bold;
}

:deep(.search-result-loc) {
  font-size: 0.8rem;
  color: var(--vp-c-text-3);
  margin-top: 4px;
}
</style>
