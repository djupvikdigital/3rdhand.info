React = require 'react'
Immutable = require 'immutable'

Elements = require '../elements.coffee'
PasswordInput = require './password-input.coffee'

{ form } = Elements

module.exports = React.createClass
	displayName: 'Form'
	propsToState: (props) ->
		return {
			placeholders: Immutable.fromJS props.placeholders
			data: Immutable.fromJS props.initialData
		}
	getDefaultProps: ->
		return {
			placeholders: {}
			initialData: {}
		}
	getInitialState: ->
		@propsToState @props
	keyResolver: (k) ->
		keys = if Array.isArray(k) then k else [ k ]
		if typeof @props.keyResolver == 'function'
			keys = @props.keyResolver.call(this, keys)
		keys
	getPlaceholder: (k) ->
		@state.placeholders.getIn @keyResolver(k)
	getValue: (k) ->
		@state.data.getIn @keyResolver(k)
	setValue: (k, v) ->
		@setState data: @state.data.setIn(@keyResolver(k), v)
	componentWillReceiveProps: (nextProps) ->
		@setState @propsToState nextProps
	handleChange: (e) ->
		@setValue e.target.name, e.target.value
	handleSubmit: (e) ->
		e.preventDefault()
		if typeof @props.onSubmit == 'function'
			@props.onSubmit @state.data.toJS()
	renderChildren: ->
		React.Children.map(
			@props.children
			((child) ->
				if child.props.name
					props =
						onChange: @handleChange
					unless child.type == PasswordInput
						props.value = @getValue(child.props.name)
					placeholder = @getPlaceholder child.props.name
					if placeholder
						props.placeholder = placeholder
					React.cloneElement child, props
				else
					child
			)
			this
		)
	render: ->
		form({ onSubmit: @handleSubmit }, @renderChildren())