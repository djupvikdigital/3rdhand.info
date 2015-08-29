React = require 'react'
Router = require 'react-router'
ReactRedux = require 'react-redux'
Reselect = require 'reselect'

localeSelector = require '../selectors/locale-selector.coffee'

mergeLocaleStrings = (state, localeState) ->
	state.localeStrings = localeState.localeStrings
	state

articleSelector = Reselect.createSelector(
	[
		require '../selectors/article-selector.coffee'
		localeSelector
	]
	mergeLocaleStrings
)
loginSelector = Reselect.createSelector(
	[
		require '../selectors/login-selector.coffee'
		localeSelector
	]
	mergeLocaleStrings
)

App = require './app.coffee'
ArticleList = ReactRedux.connect(articleSelector)(require './article-list.coffee')
LoginDialog = ReactRedux.connect(loginSelector)(require './login-dialog.coffee')

DefaultRoute = React.createFactory Router.DefaultRoute
Route = React.createFactory Router.Route

module.exports = Route(
	{ name: "app", path: "/", handler: App }
	Route(name: "admin", path: "admin", handler: LoginDialog)
	Route(path: ":year/:month/:day/:slug", handler: ArticleList)
	Route(path: ":year/:month/:day/:slug/:view", handler: ArticleList)
	DefaultRoute(handler: ArticleList)
)
