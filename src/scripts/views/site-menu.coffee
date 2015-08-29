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
		{ home, admin, newArticle } = @props.localeStrings
		newUrl = '/' + moment().format('YYYY/MM/DD') + '/untitled/new'
		ulArgs = [
			{ className: "site-menu" }
			li(Link({ to: "app"} , home))
			li(Link({ to: "admin"}, admin))
		]
		if @props.login.isLoggedIn
			ulArgs[ulArgs.length] = li({ key: "new-article" }, Link(to: newUrl, newArticle))
		nav(
			ul(ulArgs...)
		)
