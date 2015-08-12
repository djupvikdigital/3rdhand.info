React = require 'react'
Router = require 'react-router'

App = require './app.coffee'
ArticleList = require './article-list.coffee'
LoginDialog = require './login-dialog.coffee'

DefaultRoute = React.createFactory Router.DefaultRoute
Route = React.createFactory Router.Route

module.exports = Route(
	{ name: "app", path: "/", handler: App }
	Route(name: "admin", path: "admin", handler: LoginDialog)
	Route(path: ":year/:month/:day/:slug", handler: ArticleList)
	Route(path: ":year/:month/:day/:slug/:view", handler: ArticleList)
	DefaultRoute(handler: ArticleList)
)
