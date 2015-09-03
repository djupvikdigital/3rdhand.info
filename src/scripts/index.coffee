Promise = require 'bluebird'
React = require 'react'
Router = require 'react-router'

routes = require './views/routes.coffee'
store = require './store.coffee'
articleActions = require './actions/article-actions.coffee'
localeActions = require './actions/locale-actions.coffee'

Promise.all([
	store.dispatch localeActions.fetchStrings(store.getState().localeState.get('lang'))
	store.dispatch articleActions.fetchSchema()
	store.dispatch articleActions.fetch()
]).then ->
	Router.run routes, Router.HistoryLocation, (Handler, state) ->
		Handler = React.createFactory Handler
		React.render(Handler(params: state.params), document.getElementById('app'))
