React = require 'react'

createFactory = require '../create-factory.coffee'
Elements = require '../elements.coffee'

{ ul, li, div } = Elements

Link = createFactory require './link.coffee'

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