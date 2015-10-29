React = require 'react'
Immutable = require 'immutable'

Elements = require '../elements.coffee'

RadioOption = require './radio-option.coffee'

{ div, fieldset } = Elements

module.exports = (props) ->
	renderChildren = ->
		value = props.value
		props = Immutable.Map {
			name: props.name
			onChange: props.onChange
		}
		React.Children.map props.children, (child) ->
			if child.type == RadioOption
				React.cloneElement(
					child
					props.set('checked', child.props.value == value).toJS()
				)
			else
				child

	if props.label
		fieldset(
			legend(props.label)
			renderChildren()
		)
	else
		div(renderChildren())

module.exports.displayName = 'RadioGroup'
