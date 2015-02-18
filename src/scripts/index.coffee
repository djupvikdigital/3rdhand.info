React = require 'react'
Router = require 'react-router'

DefaultRoute = Router.DefaultRoute
Route = Router.Route
RouteHandler = Router.RouteHandler
Link = Router.Link

App = React.createClass
	render: ->
		<div>
			<ul>
				<li><Link to="test">Test</Link></li>
			</ul>
			<RouteHandler/>
		</div>

Test = React.createClass
	render: ->
		<h1>Test</h1>

routes = <Route name="app" path="/" handler={App}>
	<Route name="test" path="/test" handler={Test}/>
</Route>

Router.run routes, Router.HistoryLocation, (Handler) ->
	React.render(<Handler/>, document.body)
