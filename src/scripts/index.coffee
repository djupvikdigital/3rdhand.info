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
			<RouteHandler {... @props }/>
		</div>

routes = <Route name="app" path="/" handler={ App }>
	<Route path=":year/:month/:day/:slug" handler={ ArticleList }/>
	<DefaultRoute handler={ ArticleList }/>
</Route>

Router.run routes, Router.HistoryLocation, (Handler, state) ->
	React.render(<Handler params={ state.params }/>, document.body)
