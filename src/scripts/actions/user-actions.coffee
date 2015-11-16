request = require 'superagent-bluebird-promise'
t = require 'transducers.js'

protocol = 'http://'
host = 'localhost:8081'
server = protocol + host + '/'

login = (login) ->
	return {
		type: 'LOGIN'
		user: login.user
	}

logout = ->
	return {
		type: 'LOGOUT'
	}

receiveSessionSuccess = (res) ->
	return {
		type: 'RECEIVE_SESSION_SUCCESS'
		user: res.user
	}

receiveSessionError = (err) ->
	return {
		type: 'RECEIVE_SESSION_ERROR'
		error: err
	}

receiveSessionDestroySuccess = (res) ->
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

requestUser = ->
	return {
		type: 'REQUEST_LOGGEDIN_USER'
	}

receiveUserSuccess = (res) ->
	return {
		type: 'RECEIVE_LOGGEDIN_USER_SUCCESS'
		user: res.body.user || ''
	}

receiveUserError = (err) ->
	return {
		type: 'RECEIVE_LOGGEDIN_USER_ERROR'
		error: err
	}

module.exports =
	fetchUser: ->
		(dispatch) ->
			dispatch requestUser()
			request
				.get server + 'admin/session'
				.accept 'application/json'
				.promise()
				.then t.compose dispatch, receiveUserSuccess
				.catch t.compose dispatch, receiveUserError
	login: (data) ->
		(dispatch) ->
			dispatch login data
			request
				.post server + 'admin'
				.accept 'application/json'
				.send data
				.promise()
				.then t.compose dispatch, receiveSessionSuccess
				.catch t.compose dispatch, receiveSessionError
	logout: ->
		(dispatch) ->
			dispatch logout()
			request
				.get server + 'admin/logout'
				.accept 'application/json'
				.promise()
				.then t.compose dispatch, receiveSessionDestroySuccess
				.catch t.compose dispatch, receiveSessionDestroyError
	setUser: (user) ->
		return {
			type: 'SET_LOGGEDIN_USER'
			user: user
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