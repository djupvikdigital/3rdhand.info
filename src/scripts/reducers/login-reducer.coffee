Immutable = require 'immutable'

initialState = Immutable.fromJS
	isLoggedIn: false

module.exports = (state = initialState, action) ->
	switch action.type
		when 'RECEIVE_LOGGEDIN_USER_SUCCESS', 'SET_LOGGEDIN_USER'
			if action.user
				return state.merge user: action.user, isLoggedIn: true
			else
				return initialState
		when 'LOGOUT'
			return initialState
		else
			return state