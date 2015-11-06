request = require 'superagent-bluebird-promise'
t = require 'transducers.js'

protocol = 'http://'
host = 'localhost:8081'
server = protocol + host + '/'

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

module.exports =
	login: (login) ->
		return {
			type: 'LOGIN'
			user: login.user
			password: login.password
		}
	logout: ->
		return {
			type: 'LOGOUT'
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