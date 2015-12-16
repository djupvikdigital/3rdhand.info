Promise = require 'bluebird'
Immutable = require 'immutable'
ReduxRouter = require 'redux-router'

API = require 'api'
URL = require '../url.coffee'
utils = require '../utils.coffee'

module.exports =
	sessionTimeout: ->
		type: 'SESSION_TIMEOUT'
	login: (data) ->
		type: 'LOGIN'
		payload:
			promise: API.login(data).then (body) ->
				(action, dispatch, getState) ->
					params = URL.getParamsFromRouterState getState()
					params.userId = utils.getUserId body.user._id
					dispatch ReduxRouter.push URL.getPath params
					action.payload = body
					dispatch action
	logout: (userId) ->
		type: 'LOGOUT'
		payload:
			promise: API.logout(userId).then ->
				(action, dispatch, getState) ->
					path = URL.getPathFromRouterState getState()
					dispatch ReduxRouter.push path
					dispatch action
	setUser: (obj, timestamp) ->
		type: 'SET_LOGGEDIN_USER'
		payload:
			user: obj.user || obj || null
			authenticationTime: obj.timestamp || timestamp
	signup: (data) ->
		type: 'SIGNUP'
		payload:
			promise: API.signup data
