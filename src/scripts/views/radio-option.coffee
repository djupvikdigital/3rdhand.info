React = require 'react'

Elements = require '../elements.coffee'

{ label, input } = Elements

module.exports = (props) ->
	label(
		className: 'form-group--unlabeled'
		input(
			type: 'radio'
			name: props.name
			value: props.value
			checked: props.checked
			onChange: props.onChange
		)
		' ' + props.label
	)

module.exports.displayName = 'RadioOption'
