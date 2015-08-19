React = require 'react'
Router = require 'react-router'

routes = require './views/routes.coffee'
articleActions = require './actions/article-actions.coffee'

Router.run routes, Router.HistoryLocation, (Handler, state) ->
	Handler = React.createFactory Handler
	React.render(Handler(params: state.params), document.getElementById('app'))
