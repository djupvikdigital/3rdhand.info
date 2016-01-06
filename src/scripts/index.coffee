run = () ->
	ReactDOM = require 'react-dom'
	cookie = require 'cookie'
	{ XmlEntities } = require 'html-entities'

	init = require './init.coffee'
	{ store } = require './store.coffee'
	userActions = require './actions/user-actions.coffee'
	routes = require './views/routes.coffee'
	createFactory = require './create-factory.coffee'
	Root = createFactory require './views/root.coffee'
	appActions = require './actions/app-actions.coffee'

	cookies = cookie.parse document.cookie
	if cookies.session
		session = JSON.parse atob cookies.session
		if session.user && session.timestamp
			store.dispatch userActions.setUser session.user, session.timestamp

	entities = new XmlEntities()
	serverState = document.getElementById('state').textContent
	data = JSON.parse entities.decode serverState
	store.dispatch appActions.init data
	state = store.getState()
	params = state.routing.state || {}
	init params, document.documentElement.lang
		.then ->
			ReactDOM.render Root(), document.getElementById 'app'
		.catch (err) ->
			console.error err.stack

if window.Promise && Object.assign
	run()
else
	require [ 'es6-promise', 'object-assign' ], (promiseLib, assign) ->
		window.Promise || (window.Promise = promiseLib.Promise)
		Object.assign || (Object.assign = assign)
		run()
