ReduxRouter = require 'redux-simple-router'

createHandler = require './create-router-handler.coffee'
URL = require './url.coffee'
renderTemplate = require './render-template.coffee'
negotiateLang = require './negotiate-lang.coffee'
createStore = require './src/scripts/store.coffee'

module.exports = createHandler (req, res, props) ->
  if props
    params = URL.getParams props.params
    storeModule = createStore()
    { store, history } = storeModule
    url = req.originalUrl
    store.dispatch ReduxRouter.replacePath url, params
    renderTemplate storeModule, params, negotiateLang req
      .then res.send.bind res
