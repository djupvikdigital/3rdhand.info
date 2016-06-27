require('es6-promise').polyfill()
assign = require 'object-assign'
React = require 'react'
ReactDOM = require 'react-dom'
{ XmlEntities } = require 'html-entities'
ReactRouter = require 'react-router'
ReduxRouter = require 'react-router-redux'
{ createFactory } = require('react-elementary').default;

init = require './init.js'
createStore = require './store.coffee'
userActions = require './actions/userActions.js'
routes = require './views/routes.js'
Root = createFactory require './views/Root.js'
appActions = require './actions/appActions.js'
URL = require 'urlHelpers'

Router = createFactory ReactRouter.Router

Object.assign || (Object.assign = assign)

entities = new XmlEntities()
serverState = document.getElementById('state').textContent
data = JSON.parse entities.decode serverState
serverUrl = URL.getServerUrl()

{ store, history } = createStore ReactRouter.browserHistory, data

history.listen ({ pathname }) ->
  state = store.getState().appState.toJS()
  if URL.getPath(state.currentParams) != pathname
    params = state.urlsToParams[pathname] || {}
    store.dispatch appActions.setCurrentParams params

currentParams = store.getState().appState.toJS().currentParams

init store, currentParams, document.documentElement.lang
  .then ->
    ReactDOM.render(
      Root(
        { store }
        Router(
          { history }, routes
        )
      )
      document.getElementById 'app'
    )
  .catch (err) ->
    console.error err.stack || err
