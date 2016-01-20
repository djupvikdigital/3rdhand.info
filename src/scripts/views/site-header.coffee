React = require 'react'
ReactRedux = require 'react-redux'
Router = require 'react-router'

logo = require 'logo'

createFactory = require '../create-factory.coffee'
Elements = require '../elements.coffee'
selectors = require '../selectors/app-selectors.coffee'
userActions = require '../actions/user-actions.coffee'

{ div, header, nav, ul, li } = Elements

Link = createFactory ReactRedux.connect(selectors.linkSelector)(Router.Link)
LangPicker = createFactory ReactRedux.connect(selectors.langPickerSelector)(
	require './lang-picker.coffee'
)

module.exports = React.createClass
	displayName: 'SiteHeader'
	handleLogout: (e) ->
		e.preventDefault()
		data =
			id: @props.login.user._id
			from: JSON.stringify @props.params
		@props.dispatch userActions.logout data
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
		div(
			header(
				className: 'u-left', role: 'banner'
				Link className: 'site-logo', title: home, innerHtml: logo
				if @props.login.isLoggedIn
					nav(
						className: 'site-menu menu'
						ul(
							className: 'list-bare'
							li(
								key: 'new-article'
								Link params: newParams, newArticle
							)
							li key: 'logout', Link(
								slug: 'logout'
								onClick: @handleLogout
								logout
							)
						)
					)
			)
			LangPicker className: 'menu u-right'
		)
