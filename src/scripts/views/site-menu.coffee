React = require 'react'
ReactRedux = require 'react-redux'
moment = require 'moment'

createFactory = require '../create-factory.coffee'
Elements = require '../elements.coffee'
selectors = require '../selectors/app-selectors.coffee'
userActions = require '../actions/user-actions.coffee'
URL = require '../url.coffee'

{ nav, ul, li } = Elements

Link = createFactory ReactRedux.connect(selectors.linkSelector)(
	require './link.coffee'
)
LangPicker = createFactory ReactRedux.connect(selectors.langPickerSelector)(
	require './lang-picker.coffee'
)

module.exports = React.createClass
	displayName: 'SiteMenu'
	handleLogout: ->
		@props.dispatch userActions.logout()
	render: ->
		{ home, admin, newArticle, logout } = @props.localeStrings
		newUrl = '/' + moment().format('YYYY/MM/DD') + '/untitled/new'
		ulArgs = [
			className: 'list-inline'
			li Link href: '/', home
			li Link href: '/login', admin
		]
		if @props.login.isLoggedIn
			logoutUrl = URL.getUserPath(@props.login.user._id) + '/logout'
			ulArgs.push(
				li key: 'new-article', Link href: newUrl, newArticle
				li key: 'logout', Link(
					href: logoutUrl
					onClick: @handleLogout
					logout
				)
			)
		nav(
			{ className: 'site-menu' }
			LangPicker className: 'site-menu__lang-picker'
			ul ulArgs
		)
