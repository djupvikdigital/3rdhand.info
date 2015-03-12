React = require 'react'
Router = require 'react-router'

routes = require './views/routes.cjsx'

Router.run routes, Router.HistoryLocation, (Handler, state) ->
	React.render(<Handler params={ state.params }/>, document.getElementById('app'))
