React = require 'react'
ReactRedux = require 'react-redux'
moment = require 'moment'
Router = require 'react-router'

createFactory = require '../create-factory.coffee'
Elements = require '../elements.coffee'
selector = require('../selectors/app-selectors.coffee').langPickerSelector

{ nav, ul, li } = Elements

Link = createFactory Router.Link
LangPicker = createFactory(
	ReactRedux.connect(selector)(require './lang-picker.coffee')
)

module.exports = React.createClass
	displayName: 'SiteMenu'
	render: ->
		{ home, admin, newArticle } = @props.localeStrings
		newUrl = '/' + moment().format('YYYY/MM/DD') + '/untitled/new'
		ulArgs = [
			{ className: "list-inline" }
			li(Link({ to: "app"} , home))
			li(Link({ to: "admin"}, admin))
		]
		if @props.login.isLoggedIn
			ulArgs[ulArgs.length] = li({ key: "new-article" }, Link(to: newUrl, newArticle))
		nav(
			{ className: 'site-menu' }
			LangPicker className: 'site-menu__lang-picker'
			ul ulArgs
		)
