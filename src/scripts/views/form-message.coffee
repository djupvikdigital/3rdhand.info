createFactory = require '../create-factory.coffee'
{ span } = require '../elements'

Output = createFactory require './output.coffee'

module.exports = (props) ->
  if props.value
    Output
      label: props.localeStrings[props.type]
      value: props.localeStrings[props.value]
  else
    span()