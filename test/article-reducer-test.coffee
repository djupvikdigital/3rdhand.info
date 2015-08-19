expect = require 'expect'

Immutable = require 'immutable'

utils = require '../src/scripts/utils.coffee'
articleActions = require '../src/scripts/actions/article-actions.coffee'
articleReducer = require '../src/scripts/reducers/article-reducer.coffee'

describe 'articleReducer', ->
	it 'can receive articles', ->
		state = Immutable.fromJS({
			articles: [
				{ _id: '_id' }
			]
			lang: 'en'
		})
		newState = Immutable.fromJS({
			articles: [
				{ _id: '_id' }
				{ _id: '_id' }
			]
			lang: 'en'
		})
		action = articleActions.receiveArticles(newState.toJS().articles)
		output = articleReducer(state, action)
		expect(output.filterNot(utils.keyIn('lastUpdate')).toJS()).toEqual(newState.toJS())
