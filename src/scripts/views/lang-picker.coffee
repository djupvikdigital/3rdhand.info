React = require 'react'
Router = require 'react-router'

createFactory = require '../create-factory.coffee'
Elements = require '../elements.coffee'

{ ul, li, div } = Elements

Link = createFactory Router.Link

module.exports = React.createClass
	displayName: 'LangPicker'
	render: ->
		classes = [
			'lang-picker'
			'list-inline'
		]
		if @props.className
			classes[classes.length] = @props.className
		{ norwegian, english } = @props.localeStrings
		ul(
			{ className: classes.join(' ') }
			li Link { to: '/no' }, norwegian
			li Link { to: '/en' }, english
		)