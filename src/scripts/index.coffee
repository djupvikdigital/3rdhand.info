React = require 'react'
Router = require 'react-router'

routes = require './views/routes.coffee'
store = require './store.coffee'
URL = require './url.coffee'
init = require './init.coffee'

getLang = (params) ->
	l = URL.supportedLocales
	URL.negotiateLang(params.lang, l) || document.documentElement.lang

Router.run routes, Router.HistoryLocation, (Handler, state) ->
	params = state.params
	if params.splat
		params = URL.getParams state.params.splat
	init(params, getLang(params)).then ->
		Handler = React.createFactory Handler
		React.render(Handler(params: params), document.getElementById('app'))
