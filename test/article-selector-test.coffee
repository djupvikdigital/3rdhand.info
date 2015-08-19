expect = require 'expect'

Immutable = require 'immutable'

utils = require '../src/scripts/utils.coffee'
articleSelector = require '../src/scripts/selectors/article-selector.coffee'
setupState = require '../testutils/setup-state.coffee'

describe 'articleSelector', ->
	it 'returns title, articles and lang from state', ->
		state = setupState
			articles: [
				{ _id: '_id' }
				{ _id: '_id' }
			]
			foo: 'bar'
		lang = state.get('lang')
		output = articleSelector(articleState: state)
		expect(output.title).toBe(state.getIn ['title', lang])
		expect(output.articles).toEqual(state.get('articles'))
		expect(output.lang).toBe(lang)
		expect(typeof output.foo).toBe('undefined')
	it 'returns the article title merged with the title when a single article with a title is provided', ->
		state = setupState
			articles: [
				{ _id: '_id', title: { nb: { txt: 'Article Title' }}}
			]
		lang = state.get('lang')
		output = articleSelector(articleState: state)
		title = utils.getFieldValueFromFormats utils.localize lang, state.get('title').toJS()
		articleTitle = utils.getFieldValueFromFormats(
			state.getIn([ 'articles', 0, 'title', lang ]).toJS()
		)
		expect(output.title).toBe(articleTitle + ' - ' + title)
	it 'returns just the title when a single article without a title is provided', ->
		state = setupState
			articles: [
				{ _id: '_id', title: { nb: { txt: '' }}}
			]
		lang = state.get('lang')
		output = articleSelector(articleState: state)
		title = utils.getFieldValueFromFormats utils.localize lang, state.get('title').toJS()
		expect(output.title).toBe(title)