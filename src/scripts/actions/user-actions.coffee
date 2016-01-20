ReduxRouter = require 'redux-simple-router'

API = require 'api'
utils = require '../utils.coffee'
URL = require '../url.coffee'
appActions = require './app-actions.coffee'

module.exports =
	sessionTimeout: ->
		type: 'SESSION_TIMEOUT'
	login: (data) ->
		type: 'LOGIN'
		payload:
			promise: API.login(data).then (body) ->
				(action, dispatch) ->
					params = JSON.parse data.from
					params.userId = utils.getUserId body.user._id
					dispatch ReduxRouter.pushPath URL.getPath(params), params
					action.payload = body
					dispatch action
	logout: (data) ->
		type: 'LOGOUT'
		payload:
			promise: API.logout(data.id).then ->
				(action, dispatch) ->
					params = if data.from then JSON.parse data.from else {}
					delete params.userId
					dispatch ReduxRouter.pushPath URL.getPath(params), params
					dispatch action
	resetPassword: (data) ->
		type: 'RESET_PASSWORD'
		payload:
			promise: API.resetPassword data.email
	setUser: (obj, timestamp) ->
		type: 'SET_LOGGEDIN_USER'
		payload:
			user: obj.user || obj || null
			authenticationTime: obj.timestamp || timestamp
	signup: (data) ->
		type: 'SIGNUP'
		payload:
			promise: API.signup data
