React = require 'react'
Router = require 'react-router'

App = require './app.cjsx'
ArticleList = require './article-list.cjsx'
LoginDialog = require './login-dialog.cjsx'

DefaultRoute = Router.DefaultRoute
Route = Router.Route

module.exports = <Route name="app" path="/" handler={ App }>
	<Route name="admin" path="admin" handler={ LoginDialog }/>
	<Route path=":year/:month/:day/:slug" handler={ ArticleList }/>
	<Route path=":year/:month/:day/:slug/:view" handler={ ArticleList }/>
	<DefaultRoute handler={ ArticleList }/>
</Route>
