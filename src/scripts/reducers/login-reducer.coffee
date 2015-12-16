Immutable = require 'immutable'

initialState = Immutable.fromJS
	isLoggedIn: false

module.exports = (state = initialState, action) ->
	switch action.type
		when 'LOGIN_FULFILLED', 'SET_LOGGEDIN_USER'
			if action.payload.user
				return state.merge
					user: action.payload.user
					authenticationTime: action.payload.timestamp
					isLoggedIn: true
			else
				return initialState
		when 'LOGIN_REJECTED'
			return initialState.set 'error', action.payload
		when 'LOGOUT_PENDING', 'SESSION_TIMEOUT'
			return initialState
		else
			return state