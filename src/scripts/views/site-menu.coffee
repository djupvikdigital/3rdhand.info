React = require 'react'
ReactRedux = require 'react-redux'
moment = require 'moment'

createFactory = require '../create-factory.coffee'
Elements = require '../elements.coffee'
selectors = require '../selectors/app-selectors.coffee'

{ nav, ul, li } = Elements

Link = createFactory ReactRedux.connect(selectors.linkSelector)(
	require './link.coffee'
)
LangPicker = createFactory ReactRedux.connect(selectors.langPickerSelector)(
	require './lang-picker.coffee'
)

module.exports = React.createClass
	displayName: 'SiteMenu'
	render: ->
		{ home, admin, newArticle } = @props.localeStrings
		newUrl = '/' + moment().format('YYYY/MM/DD') + '/untitled/new'
		ulArgs = [
			{ className: "list-inline" }
			li Link href: '/', home
			li Link to: '/admin', admin
		]
		if @props.login.isLoggedIn
			ulArgs[ulArgs.length] = li(
				{ key: "new-article" }
				Link href: newUrl, newArticle
			)
		nav(
			{ className: 'site-menu' }
			LangPicker className: 'site-menu__lang-picker'
			ul ulArgs
		)
