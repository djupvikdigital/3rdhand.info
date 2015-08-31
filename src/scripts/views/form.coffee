React = require 'react'
Immutable = require 'immutable'

Elements = require '../elements.coffee'
PasswordInput = require './password-input.coffee'

{ form } = Elements

initialState = Immutable.fromJS
	placeholders: {}
	data: {}

module.exports = React.createClass
	displayName: 'Form'
	getInitialState: ->
		initialState.mergeDeep @props.initialState
	keyResolver: (k) ->
		keys = if Array.isArray then k else [ k ]
		if typeof @props.keyResolver == 'function'
			keys = @props.keyResolver.call(this, keys)
		keys
	getPlaceholder: (k) ->
		keys = if Array.isArray(k) then k else [ k ]
		keys.unshift 'placeholders'
		@state.getIn @keyResolver(keys)
	getValue: (k) ->
		keys = if Array.isArray(k) then k else [ k ]
		keys.unshift 'data'
		@state.getIn @keyResolver(keys)
	setValue: (k, v) ->
		keys = if Array.isArray(k) then k else [ k ]
		keys.unshift 'data'
		@replaceState @state.setIn @keyResolver(keys), v
	handleChange: (e) ->
		@setValue e.target.name, e.target.value
	handleSubmit: (e) ->
		e.preventDefault()
		if typeof @props.onSubmit == 'function'
			@props.onSubmit @state.get('data').toJS()
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