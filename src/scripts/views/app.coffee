React = require 'react'
Elements = require 'react-coffee-elements'
Router = require 'react-router'
DocumentTitle = React.createFactory require 'react-document-title'
moment = require 'moment'

loginStore = require '../stores/login-store.coffee'

{ div, nav, ul, li } = Elements
RouteHandler = React.createFactory Router.RouteHandler
Link = React.createFactory Router.Link

module.exports = React.createClass
	displayName: 'App'
	render: ->
		newUrl = '/' + moment().format('YYYY/MM/DD') + '/untitled/new'
		ulArgs = [
			{ className: "site-menu" }
			li(Link({ to: "app"} , 'Home'))
			li(Link({ to: "admin"}, 'Admin'))
		]
		if loginStore.isLoggedIn()
			ulArgs[ulArgs.length] = li({ key: "new-article"}, Link(to: newUrl, 'New article'))
		title = '3rdhand.info'
		props =
			title: title
		for own k, v of @props
			props[k] = v
		DocumentTitle(
			{ title: title }
			div(
				nav(
					ul(ulArgs...)
				)
				div(
					{ className: "wrapper"}
					RouteHandler(props)
				)
			)
		)
