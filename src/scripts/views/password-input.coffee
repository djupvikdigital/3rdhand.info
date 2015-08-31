React = require 'react'

Elements = require '../elements.coffee'

{ label, input } = Elements

module.exports = React.createClass
	displayName: 'TextInput'
	render: ->
		label(
			className: 'form-group'
			@props.label + ': '
			input(
				type: 'password'
				name: @props.name
				value: @props.value
				onChange: @props.onChange
			)
		)