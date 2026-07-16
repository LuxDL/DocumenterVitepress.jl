import assert from 'node:assert/strict'
import { pathToFileURL } from 'node:url'

const [searchOptionsPath, miniSearchPath] = process.argv.slice(2)
assert.ok(searchOptionsPath, 'expected the generated search-options.mjs path')
assert.ok(miniSearchPath, 'expected the installed MiniSearch module path')

const { documenterVitepressSearchOptions } = await import(
  pathToFileURL(searchOptionsPath).href
)
const { default: MiniSearch } = await import(pathToFileURL(miniSearchPath).href)

const { tokenize, processTerm } = documenterVitepressSearchOptions.options
const searchOptions = documenterVitepressSearchOptions.searchOptions

assert.deepEqual(tokenize('Documenter.Anchors.add!'), [
  'Documenter',
  'Anchors',
  'add!'
])
assert.deepEqual(tokenize('Base.:+'), ['Base', ':+'])
assert.deepEqual(tokenize('Array{T,N}'), ['Array', 'T', 'N'])
assert.deepEqual(tokenize('f(x::Int)'), ['f', 'x', 'Int'])
assert.deepEqual(tokenize('full-text'), ['full', 'text'])
assert.deepEqual(tokenize('@time isready?'), ['@time', 'isready?'])
assert.deepEqual(tokenize('σₓ ⊗ ∂'), ['σₓ', '⊗', '∂'])

assert.equal(processTerm('The'), null)
assert.equal(processTerm('HOW'), null)
assert.equal(processTerm('ADD!'), 'add!')
assert.equal(processTerm('get'), 'get')
assert.equal(processTerm('in'), 'in')
assert.equal(processTerm('while'), 'while')

assert.equal(searchOptions.combineWith, 'AND')
assert.equal(searchOptions.prefix, true)
assert.equal(searchOptions.fuzzy('four'), false)
assert.equal(searchOptions.fuzzy('fives'), 0.2)
assert.deepEqual(searchOptions.boost, { title: 10, titles: 2, text: 1 })

const search = new MiniSearch({
  fields: ['title', 'titles', 'text'],
  storeFields: ['title', 'titles', 'text'],
  ...documenterVitepressSearchOptions.options,
  searchOptions
})

search.addAll([
  {
    id: 'exact-title',
    title: 'Documenter.Anchors.add!',
    titles: ['API Reference'],
    text: 'Register an anchor in the document.'
  },
  {
    id: 'ancestor-title',
    title: 'Examples',
    titles: ['Documenter.Anchors.add!'],
    text: 'Reference examples.'
  },
  {
    id: 'body-mention',
    title: 'Navigation guide',
    titles: ['Guide'],
    text: 'This page mentions the add! function in prose.'
  },
  {
    id: 'both-terms',
    title: 'Building the search index',
    titles: ['Search'],
    text: 'Configure local results.'
  },
  {
    id: 'search-only',
    title: 'Search configuration',
    titles: ['Guide'],
    text: 'Configure local results.'
  },
  {
    id: 'index-only',
    title: 'Index construction',
    titles: ['Guide'],
    text: 'Build an index efficiently.'
  },
  {
    id: 'short-fuzzy-decoy',
    title: 'az',
    titles: ['API Reference'],
    text: 'A short identifier.'
  }
])

const ids = (query) => search.search(query).map(({ id }) => id)

assert.deepEqual(ids('add!').slice(0, 3), [
  'exact-title',
  'ancestor-title',
  'body-mention'
])
assert.deepEqual(ids('how to add!'), ids('add!'))
assert.deepEqual(ids('search index'), ['both-terms'])
assert.ok(ids('Docu').includes('exact-title'))
assert.ok(ids('Documemter').includes('exact-title'))
assert.deepEqual(ids('zz'), [])

console.log('DocumenterVitepress search options tests passed')
