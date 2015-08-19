React = require 'react'
moment = require 'moment'
Router = require 'react-router'

createFactory = require '../create-factory.coffee'
Elements = require '../elements.coffee'

{ nav, ul, li } = Elements
Link = createFactory Router.Link

module.exports = React.createClass
	displayName: 'SiteMenu'
	render: ->
		newUrl = '/' + moment().format('YYYY/MM/DD') + '/untitled/new'
		ulArgs = [
			{ className: "site-menu" }
			li(Link({ to: "app"} , 'Home'))
			li(Link({ to: "admin"}, 'Admin'))
		]
		if @props.isLoggedIn
			ulArgs[ulArgs.length] = li({ key: "new-article" }, Link(to: newUrl, 'New article'))
		nav(
			ul(ulArgs...)
		)
