React = require 'react'
Immutable = require 'immutable'

Elements = require '../elements.coffee'

RadioOption = require './radio-option.coffee'

{ div, fieldset } = Elements

renderChildren = (_props) ->
  value = _props.value
  props = Immutable.Map
    name: _props.name
    onChange: _props.onChange
  React.Children.map _props.children, (child) ->
    if child.type == RadioOption
      React.cloneElement(
        child
        props.set('checked', child.props.value == value).toJS()
        child.props.children
      )
    else
      child

module.exports = (props) ->
  if props.label
    fieldset(
      legend(props.label)
      renderChildren props
    )
  else
    div renderChildren props

module.exports.displayName = 'RadioGroup'
