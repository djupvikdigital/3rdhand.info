expect = require 'expect'

Immutable = require 'immutable'
YAML = require 'js-yaml'

createStore = require '../src/scripts/store.coffee'
utils = require '../src/scripts/utils.coffee'
selectors = require '../src/scripts/selectors/article-selectors.coffee'
{ read } = require '../utils.coffee'

describe 'articleSelectors', ->
	describe 'containerSelector', ->
		it 'returns articles from state', ->
			{ store } = createStore()
			state = store.getState()
			state.articleState = state.articleState.merge
				articles: [
					{ _id: '_id' }
					{ _id: '_id' }
				]
			output = selectors.containerSelector(state)
			state = state.articleState
			expect(output.articles).toEqual(state.get('articles').toJS())
	describe 'itemSelector', ->
		it 'returns the article title merged with the title when a single article with a title is provided', ->
			{ store } = createStore()
			state = store.getState()
			lang = state.localeState.get('lang')
			localeStrings = YAML.safeLoad read 'locales/' + lang + '.yaml'
			store.dispatch
				type: 'FETCH_LOCALE_STRINGS_FULFILLED'
				payload:
					lang: lang
					data: localeStrings
			state = store.getState()
			state.articleState = state.articleState.merge
				articles: [
					{ _id: '_id', title: { nb: { format: '', text: 'Article Title' }}}
				]
			output = selectors.itemSelector(state)
			{ title } = localeStrings
			articleTitle = state.articleState.getIn(
				[ 'articles', 0, 'title', lang, 'text' ]
			)
			expect(output.title).toBe(articleTitle + ' - ' + title)
		it 'returns just the title when a single article without a title is provided', ->
			{ store } = createStore()
			state = store.getState()
			lang = state.localeState.get('lang')
			localeStrings = YAML.safeLoad read 'locales/' + lang + '.yaml'
			store.dispatch
				type: 'FETCH_LOCALE_STRINGS_FULFILLED'
				payload:
					lang: lang
					data: localeStrings
			state = store.getState()
			state.articleState = state.articleState.merge
				articles: [
					{ _id: '_id', title: { nb: { format: '', text: '' }}}
				]
			output = selectors.itemSelector(state)
			{ title } = localeStrings
			expect(output.title).toBe(title)
