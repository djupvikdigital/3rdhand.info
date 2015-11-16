React = require 'react'
ReactDOM = require 'react-dom'
ReduxRouter = require 'redux-router'

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

unsubscribe = store.subscribe(->
	state = store.getState().router
	params = state.params
	if params.splat
		params = URL.getParams params.splat
	unsubscribe()
	init params, getLang params
		.then ->
			store.dispatch userActions.fetchUser()
		.then ->
			ReactDOM.render Root(), document.getElementById 'app'
)

store.dispatch { type: 'INIT' }
