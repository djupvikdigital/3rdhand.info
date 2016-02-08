ReduxRouter = require 'react-router-redux'

createHandler = require './create-router-handler.coffee'
URL = require '../src/node_modules/url-helpers.coffee'
renderTemplate = require './render-template.coffee'
negotiateLang = require './negotiate-lang.coffee'
createStore = require '../src/scripts/store.coffee'

module.exports = createHandler (req, res, props) ->
  if props
    params = URL.getParams props.params
    storeModule = createStore()
    { store, history } = storeModule
    url = req.originalUrl
    store.dispatch ReduxRouter.routeActions.replace pathname: url, state: params
    serverUrl = URL.getServerUrl req
    renderTemplate storeModule, serverUrl, params, negotiateLang req
      .then res.send.bind res
