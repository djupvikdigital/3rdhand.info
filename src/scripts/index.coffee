React = require 'react'
Router = require 'react-router'

routes = require './views/routes.coffee'
store = require './store.coffee'
URL = require './url.coffee'
init = require './init.coffee'

Router.run routes, Router.HistoryLocation, (Handler, state) ->
	params = state.params
	supportedLocales = store.getState().localeState.toJS().supportedLocales
	if params.splat
		params = URL.getParams state.params.splat
	lang = (
		URL.negotiateLang(params.lang, supportedLocales) ||
		document.documentElement.lang
	)
	init(params, lang).then ->
		Handler = React.createFactory Handler
		React.render(Handler(params: params), document.getElementById('app'))
