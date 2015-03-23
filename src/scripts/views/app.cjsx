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
		title = '3rdhand.info'
		<DocumentTitle title={ title }>
			<div>
				<header role="banner" className="site-header"><img className="site-header__logo" src="/dist/svg/logo.svg" alt=""/> { title }</header>
				<div className="wrapper">
					<ul>
						<li><Link to="app">Home</Link></li>
						<li><Link to="admin">Admin</Link></li>
						{ newArticleLink }
					</ul>
					<RouteHandler title={ title } {... @props }/>
				</div>
			</div>
		</DocumentTitle>
