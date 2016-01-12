expect = require 'expect'

Immutable = require 'immutable'

articleActions = require '../src/scripts/actions/article-actions.coffee'
createStore = require '../src/scripts/store.coffee'

describe 'store', ->
	describe 'localeState', ->
		it 'has a language', ->
			{ store } = createStore()
			state = store.getState().localeState
			expect(state.has('lang')).toBe(true)
			expect(typeof state.get('lang')).toBe('string')
	describe 'articleState', ->
		it 'has a list of articles', ->
			{ store } = createStore()
			state = store.getState().articleState
			expect(state.has('articles')).toBe(true)
			expect(Immutable.List.isList(state.get('articles'))).toBe(true)
