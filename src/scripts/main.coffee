require('es6-promise').polyfill()
assign = require 'object-assign'
React = require 'react'
ReactDOM = require 'react-dom'
{ XmlEntities } = require 'html-entities'
ReactRouter = require 'react-router'
ReduxRouter = require 'react-router-redux'

init = require './init.coffee'
createStore = require './store.coffee'
userActions = require './actions/user-actions.coffee'
routes = require './views/routes.coffee'
createFactory = require './create-factory.coffee'
Root = createFactory require './views/root.coffee'
appActions = require './actions/app-actions.coffee'
URL = require 'url-helpers'

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
    console.log params
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
