React = require 'react'
Router = require 'react-router'

App = require './app.cjsx'
ArticleList = require './article-list.cjsx'

DefaultRoute = Router.DefaultRoute
Route = Router.Route

module.exports = <Route name="app" path="/" handler={ App }>
	<Route path=":year/:month/:day/:slug" handler={ ArticleList }/>
	<DefaultRoute handler={ ArticleList }/>
</Route>
