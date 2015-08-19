Immutable = require 'immutable'

validLogin = require('../utils.coffee').validLogin

initialState = Immutable.fromJS
	isLoggedIn: false

module.exports = (state = initialState, action) ->
	switch action.type
		when 'LOGIN'
			if validLogin(action)
				return state.merge({
					user: action.user
					password: action.password
					isLoggedIn: true
				})
			else
				return state
		when 'LOGOUT'
			return initialState
		else
			return state