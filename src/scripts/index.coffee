React = require 'react'
Router = require 'react-router'

routes = require './views/routes.coffee'
init = require './init.coffee'

Router.run routes, Router.HistoryLocation, (Handler, state) ->
	params = state.params
	init(params).then ->
		Handler = React.createFactory Handler
		React.render(Handler(params: params), document.getElementById('app'))
