React = require 'react'
Router = require 'react-router'
DocumentTitle = require 'react-document-title'
moment = require 'moment'

loginStore = require '../stores/login-store.coffee'

RouteHandler = Router.RouteHandler
Link = Router.Link

module.exports = React.createClass
	displayName: 'App'
	render: ->
		newUrl = '/' + moment().format('YYYY/MM/DD') + '/untitled/new'
		if loginStore.isLoggedIn()
			newArticleLink = <li key="new-article"><Link to={ newUrl }>New article</Link></li>
		title = 'Third Hand Information'
		<DocumentTitle title={ title }>
			<div>
				<header role="banner" className="alpha"><img className="logo" src="/dist/svg/logo.svg" alt=""/> { title }</header>
				<ul>
					<li><Link to="app">Home</Link></li>
					<li><Link to="admin">Admin</Link></li>
					{ newArticleLink }
				</ul>
				<RouteHandler title={ title } {... @props }/>
			</div>
		</DocumentTitle>
