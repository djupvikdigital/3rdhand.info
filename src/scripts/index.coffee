React = require 'react'
Router = require 'react-router'

routes = require './views/routes.cjsx'
articleActions = require './actions/article-actions.coffee'

Router.run routes, Router.HistoryLocation, (Handler, state) ->
	articleActions.fetch.triggerPromise(state.params).then((articles) ->
		React.render(<Handler params={ state.params }/>, document.getElementById('app'))
	).catch (err) ->
		console.log 'Fetch error: ' + err
