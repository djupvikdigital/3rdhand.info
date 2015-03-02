React = require 'react'
Router = require 'react-router'
DocumentTitle = require 'react-document-title'

RouteHandler = Router.RouteHandler
Link = Router.Link

module.exports = React.createClass
	render: ->
		title = 'Third Hand Information'
		<DocumentTitle title={ title }>
			<div className="wrapper">
				<header role="banner"><img className="logo" src="/dist/svg/logo.svg" alt=""/> Third Hand Information</header>
				<ul>
					<li><Link to="app">Home</Link></li>
				</ul>
				<RouteHandler title={ title } {... @props }/>
			</div>
		</DocumentTitle>
