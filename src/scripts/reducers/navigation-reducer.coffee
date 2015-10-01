Immutable = require 'immutable'

initialState = Immutable.fromJS
	params: {}

module.exports = (state = initialState, action) ->
	switch action.type
		when 'SET_PARAMS'
			return state.merge params: action.params
		else
			return state