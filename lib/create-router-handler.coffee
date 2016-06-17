ReactRouter = require 'react-router'
ReduxRouter = require 'react-router-redux'

actions = require '../src/scripts/actions/app-actions.coffee'
negotiateLang = require './negotiate-lang.coffee'
createStore = require '../src/scripts/store.coffee'
routes = require '../src/scripts/views/routes.coffee'
URL = require '../src/node_modules/url-helpers.coffee'

module.exports = (propsHandler) ->
  (req, res) ->
    url = req.originalUrl
    config =
      routes: routes
      location: url
      history: ReactRouter.createMemoryHistory()

    ReactRouter.match config, (err, redirectLocation, props) ->
      if err
        res.status(500).send err.message
      else if redirectLocation
        res.redirect(
          302
          redirectLocation.pathname + redirectLocation.search
        )
      else
        params = URL.getParams props.params
        storeModule = createStore props.router
        { store } = storeModule
        store.dispatch actions.setCurrentParams params
        propsHandler(
          req
          res
          lang: negotiateLang req
          params: params
          props: props
          storeModule: storeModule
          serverUrl: URL.getServerUrl req
        )
