// MiniSearch defaults tuned for Julia documentation.

// Based on Documenter's long-standing stop-word list, with names from Base
// (all, any, get, in, is, only, which) and Julia keywords
// (do, else, for, let, where, while, with) intentionally retained.
function tokenizeJuliaTerms(text) {
  if (!globalThis._juliaTermPattern) {
    globalThis._juliaTermPattern = /@[\p{L}_][\p{L}\p{M}\p{N}_]*[!?]?|[\p{L}_][\p{L}\p{M}\p{N}_]*[!?]?|\p{N}+(?:\.\p{N}+)?|(?<![\p{L}\p{M}\p{N}_])(?:[+\-*\/\\^%<>=!&|~?:.]+|\p{Sm}+)(?![\p{L}\p{M}\p{N}_])/gu;
  }
  return text.match(globalThis._juliaTermPattern) ?? []
}

function processJuliaTerm(term) {
  if (!globalThis._juliaStopWords) {
    globalThis._juliaStopWords = new Set([
      'a','able','about','across','after','almost','also','am','among','an','and','are','as','at','be','because','been','but','by','can','cannot','could','dear','did','does','either','ever','every','from','got','had','has','have','he','her','hers','him','his','how','however','i','if','into','it','its','just','least','like','likely','may','me','might','most','must','my','neither','no','nor','not','of','off','often','on','or','other','our','own','rather','said','say','says','she','should','since','so','some','than','that','the','their','them','then','there','these','they','this','tis','to','too','twas','us','wants','was','we','were','what','when','who','whom','why','will','would','yet','you','your'
    ])
  }
  const normalized = term.toLowerCase()
  return globalThis._juliaStopWords.has(normalized) ? null : normalized
}

/**
 * Julia-aware defaults for VitePress local search.
 *
 * @type {NonNullable<import('vitepress').DefaultTheme.LocalSearchOptions['miniSearch']>}
 */
export const documenterVitepressSearchOptions = {
  options: {
    tokenize: tokenizeJuliaTerms,
    processTerm: processJuliaTerm
  },
  searchOptions: {
    combineWith: 'AND',
    prefix: true,
    fuzzy: (term) => (term.length >= 5 ? 0.2 : false),
    boost: { title: 10, titles: 2, text: 1 }
  }
}
