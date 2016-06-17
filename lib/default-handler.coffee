{ replace } = require 'react-router-redux'

createHandler = require './create-router-handler.coffee'
renderTemplate = require './render-template.coffee'

module.exports = createHandler (req, res, config) ->
  { props } = config
  if props
    renderTemplate config
      .then res.send.bind res
