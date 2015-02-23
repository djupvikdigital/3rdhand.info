React = require 'react'
Router = require 'react-router'

ArticleList = require './views/article-list.cjsx'

DefaultRoute = Router.DefaultRoute
Route = Router.Route
RouteHandler = Router.RouteHandler
Link = Router.Link

App = React.createClass
	render: ->
		<div>
			<ul>
				<li><Link to="app">Home</Link></li>
			</ul>
			<RouteHandler/>
		</div>

routes = <Route name="app" path="/" handler={ App }>
	<DefaultRoute handler={ ArticleList }/>
</Route>

Router.run routes, Router.HistoryLocation, (Handler) ->
	React.render(<Handler/>, document.body)
