React = require 'react'

Elements = require '../elements.coffee'

{ label, output } = Elements

module.exports = React.createClass
  displayName: 'Output'
  render: ->
    label(
      className: 'form-group'
      @props.label + ': '
      output(
        { name: @props.name }
        @props.value
      )
    )