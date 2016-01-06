API = require 'api'
utils = require '../utils.coffee'
appActions = require './app-actions.coffee'

module.exports =
	sessionTimeout: ->
		type: 'SESSION_TIMEOUT'
	login: (data) ->
		type: 'LOGIN'
		payload:
			promise: API.login(data).then (body) ->
				(action, dispatch) ->
					params = userId: utils.getUserId body.user._id
					dispatch appActions.mergeParams params
					action.payload = body
					dispatch action
	logout: (userId) ->
		type: 'LOGOUT'
		payload:
			promise: API.logout userId
	setUser: (obj, timestamp) ->
		type: 'SET_LOGGEDIN_USER'
		payload:
			user: obj.user || obj || null
			authenticationTime: obj.timestamp || timestamp
	signup: (data) ->
		type: 'SIGNUP'
		payload:
			promise: API.signup data
