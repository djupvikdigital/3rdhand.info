expect = require 'expect'

Immutable = require 'immutable'

utils = require '../src/scripts/utils.coffee'
articleReducer = require '../src/scripts/reducers/article-reducer.coffee'

describe 'articleReducer', ->
	it 'can receive articles', ->
		state = Immutable.fromJS({
			articles: [
				{ _id: '_id' }
			]
			lang: 'en'
			error: null
			refetch: false
		})
		newState = Immutable.fromJS({
			articles: [
				{ _id: '_id' }
				{ _id: '_id' }
			]
			lang: 'en'
			error: null
			refetch: false
		})
		action =
			type: 'FETCH_ARTICLES_FULFILLED'
			payload:
				docs: newState.get('articles').toJS()
		output = articleReducer(state, action)
		expect(output.filterNot(utils.keyIn('lastUpdate')).toJS()).toEqual(newState.toJS())
