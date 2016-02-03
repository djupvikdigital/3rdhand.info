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
      action: ''
      method: 'GET'
      placeholders: {}
      initialData: {}
      error: ''
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
    if @isMounted()
      @setState data: @state.data.setIn @keyResolver(k), v
  componentWillReceiveProps: (nextProps) ->
    @setState @propsToState nextProps
  handleChange: (e) ->
    @setValue e.target.name, e.target.value
  handleSubmit: (e) ->
    if typeof @props.onSubmit == 'function'
      e.preventDefault()
      Promise.resolve @props.onSubmit @state.data.toJS()
        .then =>
          @setValue 'error', ''
        .catch (err) =>
          @setValue 'error', err.message
  renderChild: (child) ->
    if !child.props
      return child
    children = null
    if child.props.children
      children = React.Children.map child.props.children, @renderChild, this
    if child.props.name
      props =
        onChange: @handleChange
      unless child.type == PasswordInput
        props.value = @getValue(child.props.name)
      placeholder = @getPlaceholder child.props.name
      if placeholder
        props.placeholder = placeholder
      if children
        React.cloneElement child, props, children
      else
        React.cloneElement child, props
    else if children
      React.cloneElement child, {}, children
    else
      child
  render: ->
    form(
      action: @props.action
      method: @props.method
      onSubmit: @handleSubmit
      React.Children.map @props.children, @renderChild, this
    )