React = require 'react'
Router = require 'react-router'
ReactRedux = require 'react-redux'

actions = require '../actions/locale-actions.coffee'
selector = require('../selectors/app-selectors.coffee').linkSelector
createFactory = require '../create-factory.coffee'
Elements = require '../elements.coffee'

{ ul, li, div } = Elements

Link = createFactory ReactRedux.connect(selector)(Router.Link)

propFactory = (props, langParam) ->
	params = props.params
	onClick = ->
		props.dispatch actions.fetchStrings langParam
	return { params, langParam, onClick }

module.exports = (props) ->
	classes = [
		'lang-picker'
		'list-inline'
	]
	if props.className
		classes[classes.length] = props.className
	{ norwegian, english } = props.localeStrings
	ul(
		className: classes.join(' ')
		li Link propFactory(props, 'no'), norwegian
		li Link propFactory(props, 'en'), english
	)

module.exports.displayName = 'LangPicker'
