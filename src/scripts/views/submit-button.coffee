{ input } = require '../elements.coffee'

module.exports = (props) ->
  childProps =
    className: 'btn'
    type: 'submit'
    name: props.name
    value: props.children
  if typeof props.onChange == 'function'
    childProps.onClick = props.onChange
  input childProps
