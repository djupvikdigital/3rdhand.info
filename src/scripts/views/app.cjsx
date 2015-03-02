React = require 'react'
Router = require 'react-router'

RouteHandler = Router.RouteHandler
Link = Router.Link

module.exports = React.createClass
	render: ->
		<div>
			<ul>
				<li><Link to="app">Home</Link></li>
			</ul>
			<RouteHandler {... @props }/>
		</div>
