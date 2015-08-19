Immutable = require 'immutable'

module.exports = (state) ->
	initialState = Immutable.fromJS
		title:
			nb:
				'Test'
		articles: []
		lang: 'nb'
	initialState.merge(state)