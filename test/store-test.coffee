expect = require 'expect'

Immutable = require 'immutable'

articleActions = require '../src/scripts/actions/article-actions.coffee'
createStore = require '../testutils/create-store.coffee'

describe 'store', ->
	describe 'localeState', ->
		it 'has a language', ->
			store = createStore()
			state = store.getState().localeState
			expect(state.has('lang')).toBe(true)
			expect(typeof state.get('lang')).toBe('string')
	describe 'articleState', ->
		it 'has a list of articles', ->
			store = createStore()
			state = store.getState().articleState
			expect(state.has('articles')).toBe(true)
			expect(Immutable.List.isList(state.get('articles'))).toBe(true)
		it 'can receive articles', ->
			store = createStore()
			article = { _id: '_id' }
			state = Immutable.fromJS({
				articles: [ article ]
			})
			store.dispatch articleActions.receiveArticles([ article ])
			newState = store.getState().articleState
			expect(newState.get('articles').toJS()).toEqual(state.get('articles').toJS())