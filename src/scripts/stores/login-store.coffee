Reflux = require 'reflux'

actions = require '../actions/login-actions.coffee'

login = {}

module.exports = Reflux.createStore
	init: ->
		@listenTo actions.login, @setUser
		@listenTo actions.logout, @setUser
	isLoggedIn: ->
		@validLogin login
	getLogin: ->
		login
	setUser: (obj) ->
		login = if @validLogin(obj) then obj else {}
		@trigger(@getLogin())
	validLogin: (obj) ->
		return typeof obj == "object" && 'user' of obj && 'password' of obj