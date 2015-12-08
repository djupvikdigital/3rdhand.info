React = require 'react'
ReactDOM = require 'react-dom'
ReduxRouter = require 'redux-router'
cookie = require 'cookie'

init = require './init.coffee'
URL = require './url.coffee'
store = require './store.coffee'
userActions = require './actions/user-actions.coffee'
routes = require './views/routes.coffee'
createFactory = require './create-factory.coffee'
Root = createFactory require './views/root.coffee'

Router = createFactory ReduxRouter.ReduxRouter

getLang = (params) ->
	l = URL.supportedLocales
	URL.negotiateLang(params.lang, l) || document.documentElement.lang

unsubscribe = store.subscribe ->
	state = store.getState().router
	params = URL.getParams state.params
	unsubscribe()
	init params, getLang params
		.then ->
			ReactDOM.render Root(), document.getElementById 'app'
		.catch (err) ->
			console.error err

cookies = cookie.parse document.cookie
if cookies.session
	session = JSON.parse atob cookies.session
	if session.user && session.timestamp
		store.dispatch userActions.setUser session.user, session.timestamp

store.dispatch { type: 'INIT' }
