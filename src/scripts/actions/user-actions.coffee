Promise = require 'bluebird'
ReduxRouter = require 'redux-router'

API = require '../api.coffee'
URL = require '../url.coffee'

module.exports =
	sessionTimeout: ->
		type: 'SESSION_TIMEOUT'
	login: (data) ->
		type: 'LOGIN'
		payload:
			promise: API.login(data).then (res) ->
				(action, dispatch, getState) ->
					userPath = URL.getUserPath res.body.user._id
					path = userPath + URL.getPathFromRouterState getState()
					dispatch ReduxRouter.push path
					action.payload = res.body
					dispatch action
	logout: (userId) ->
		type: 'LOGOUT'
		payload:
			promise: API.logout(userId).then (res) ->
				(action, dispatch, getState) ->
					path = URL.getPathFromRouterState getState()
					dispatch ReduxRouter.push path
					action.payload = res.body
					dispatch action
	setUser: (user, timestamp) ->
		type: 'SET_LOGGEDIN_USER'
		payload:
			user: user || null
			authenticationTime: timestamp
	signup: (data) ->
		type: 'SIGNUP'
		payload:
			promise: API.signup data
