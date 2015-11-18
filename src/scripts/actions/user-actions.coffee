request = require 'superagent-bluebird-promise'
ReduxRouter = require 'redux-router'
t = require 'transducers.js'

URL = require '../url.coffee'

protocol = 'http://'
host = 'localhost:8081'
server = protocol + host + '/'

login = (login) ->
	return {
		type: 'LOGIN'
	}

logout = ->
	return {
		type: 'LOGOUT'
	}

receiveSessionDestroySuccess = ->
	return {
		type: 'RECEIVE_SESSION_DESTROY_SUCCESS'
	}

receiveSessionDestroyError = (err) ->
	return {
		type: 'RECEIVE_SESSION_DESTROY_ERROR'
		error: err
	}


requestSignup = (data) ->
	return {
		type: 'REQUEST_SIGNUP'
		user: data.user
		password: data.password
		repeatPassword: data.repeatPassword
	}

receiveSignupSuccess = (res) ->
	return {
		type: 'RECEIVE_SIGNUP_SUCCESS'
		response: res
	}

receiveSignupError = (err) ->
	return {
		type: 'RECEIVE_SIGNUP_ERROR'
		error: err
	}

receiveUserSuccess = (res) ->
	return {
		type: 'RECEIVE_LOGGEDIN_USER_SUCCESS'
		user: res.body.user || null
	}

receiveUserError = (err) ->
	return {
		type: 'RECEIVE_LOGGEDIN_USER_ERROR'
		error: err
	}

module.exports =
	login: (data) ->
		(dispatch) ->
			dispatch login data
			request
				.post server + 'users'
				.accept 'application/json'
				.send data
				.promise()
				.then (res) ->
					dispatch receiveUserSuccess res
					dispatch ReduxRouter.pushState(
						null, URL.getUserPath res.body.user._id
					)
				.catch t.compose dispatch, receiveUserError
	logout: ->
		(dispatch, getState) ->
			user = getState().loginState.toJS().user
			dispatch logout()
			request
				.get protocol + host + URL.getUserPath(user._id) + '/logout'
				.accept 'application/json'
				.promise()
				.then ->
					dispatch receiveSessionDestroySuccess()
					dispatch ReduxRouter.pushState null, '/'
				.catch t.compose dispatch, receiveSessionDestroyError
	setUser: (user) ->
		return {
			type: 'SET_LOGGEDIN_USER'
			user: user || null
		}
	signup: (data) ->
		(dispatch) ->
			dispatch requestSignup data
			request
				.post server + 'signup'
				.accept 'application/json'
				.send data
				.promise()
				.then t.compose dispatch, receiveSignupSuccess
				.catch t.compose dispatch, receiveSignupError