React = require 'react'
ReactRedux = require 'react-redux'

selector = require('../selectors/app-selectors.coffee').linkSelector
createFactory = require '../create-factory.coffee'
Elements = require '../elements.coffee'

{ ul, li, div } = Elements

Link = createFactory ReactRedux.connect(selector)(require './link.coffee')

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
		li Link { langParam: 'no' }, norwegian
		li Link { langParam: 'en' }, english
	)

module.exports.displayName = 'LangPicker'
