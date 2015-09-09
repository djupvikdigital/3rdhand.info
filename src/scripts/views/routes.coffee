React = require 'react'
Router = require 'react-router'
ReactRedux = require 'react-redux'

articleSelectors = require '../selectors/article-selectors.coffee'
loginSelector = require('../selectors/app-selectors.coffee').loginSelector
App = require './app.coffee'
ArticleContainer = ReactRedux.connect(
	articleSelectors.containerSelector
)(require './article-container.coffee')
LoginDialog = ReactRedux.connect(loginSelector)(require './login-dialog.coffee')

DefaultRoute = React.createFactory Router.DefaultRoute
Route = React.createFactory Router.Route

module.exports = Route(
	{ name: "app", path: "/", handler: App }
	Route(name: "admin", path: "admin", handler: LoginDialog)
	Route(path: ":year/:month/:day/:slug", handler: ArticleContainer)
	Route(path: ":year/:month/:day/:slug/:view", handler: ArticleContainer)
	DefaultRoute(handler: ArticleContainer)
)
