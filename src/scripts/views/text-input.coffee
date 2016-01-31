React = require 'react'

Elements = require '../elements.coffee'

{ label, input, textarea } = Elements

module.exports = React.createClass
  displayName: 'TextInput'
  getDefaultProps: ->
    { multiline: false, placeholder: '' }
  render: ->
    el = if @props.multiline then textarea else input
    label(
      className: 'form-group'
      @props.label + ': '
      el(
        name: @props.name
        value: @props.value
        placeholder: @props.placeholder
        onChange: @props.onChange
      )
    )