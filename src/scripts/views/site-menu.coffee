React = require 'react'
ReactRedux = require 'react-redux'
Router = require 'react-router'

createFactory = require '../create-factory.coffee'
Elements = require '../elements.coffee'
selectors = require '../selectors/app-selectors.coffee'
userActions = require '../actions/user-actions.coffee'

{ nav, ul, li } = Elements

Link = createFactory ReactRedux.connect(selectors.linkSelector)(Router.Link)
LangPicker = createFactory ReactRedux.connect(selectors.langPickerSelector)(
	require './lang-picker.coffee'
)

module.exports = React.createClass
	displayName: 'SiteMenu'
	handleLogout: ->
		@props.dispatch userActions.logout @props.login.user._id
	render: ->
		{ home, login, newArticle, logout } = @props.localeStrings
		now = new Date()
		newParams = {
			year: now.getFullYear()
			month: now.getMonth() + 1
			day: now.getDate()
			slug: 'untitled'
			view: 'new'
		}
		ulArgs = [
			className: 'list-inline'
			li Link home
		]
		if @props.login.isLoggedIn
			ulArgs.push(
				li key: 'new-article', Link newParams, newArticle
				li key: 'logout', Link(
					slug: 'logout'
					onClick: @handleLogout
					logout
				)
			)
		else
			ulArgs.push(
				li key: 'login', Link slug: 'login', login
			)
		nav(
			{ className: 'site-menu' }
			LangPicker className: 'site-menu__lang-picker'
			ul ulArgs
		)
