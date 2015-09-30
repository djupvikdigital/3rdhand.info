React = require 'react'
Router = require 'react-router'

routes = require './views/routes.coffee'
store = require './store.coffee'
URL = require './url.coffee'
init = require './init.coffee'

Router.run routes, Router.HistoryLocation, (Handler, state) ->
	params = state.params
	if params.splat
		supportedLocales = store.getState().localeState.toJS().supportedLocales
		params = URL.getParams state.params.splat, supportedLocales
	lang = params.lang || document.documentElement.lang
	init(params, lang).then ->
		Handler = React.createFactory Handler
		React.render(Handler(params: params), document.getElementById('app'))
