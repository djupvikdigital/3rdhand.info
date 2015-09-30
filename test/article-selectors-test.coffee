expect = require 'expect'

Immutable = require 'immutable'

utils = require '../src/scripts/utils.coffee'
selectors = require '../src/scripts/selectors/article-selectors.coffee'
setupState = require '../testutils/setup-state.coffee'

describe 'articleSelectors', ->
	describe 'containerSelector', ->
		it 'returns articles and lang from state', ->
			state = setupState
				articles: [
					{ _id: '_id' }
					{ _id: '_id' }
				]
			lang = state.localeState.get('lang')
			output = selectors.containerSelector(state)
			state = state.articleState
			expect(output.articles).toEqual(state.get('articles').toJS())
			expect(output.lang).toBe(lang)
	describe 'itemSelector', ->
		it 'returns the article title merged with the title when a single article with a title is provided', ->
			state = setupState
				articles: [
					{ _id: '_id', title: { nb: { format: '', text: 'Article Title' }}}
				]
			lang = state.localeState.get('lang')
			output = selectors.itemSelector(state)
			title = state.localeState.toJS().localeStrings.title
			articleTitle = utils.getFieldValueFromFormats(
				state.articleState.getIn([ 'articles', 0, 'title', lang ]).toJS()
			)
			expect(output.title).toBe(articleTitle + ' - ' + title)
		it 'returns just the title when a single article without a title is provided', ->
			state = setupState
				articles: [
					{ _id: '_id', title: { nb: { format: '', text: '' }}}
				]
			lang = state.localeState.get('lang')
			output = selectors.itemSelector(state)
			title = state.localeState.toJS().localeStrings.title
			expect(output.title).toBe(title)
