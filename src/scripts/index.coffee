require('es6-promise').polyfill()
assign = require 'object-assign'
ReactDOM = require 'react-dom'
{ XmlEntities } = require 'html-entities'
ReduxRouter = require 'redux-simple-router'

init = require './init.coffee'
createStore = require './store.coffee'
userActions = require './actions/user-actions.coffee'
routes = require './views/routes.coffee'
createFactory = require './create-factory.coffee'
Root = createFactory require './views/root.coffee'
appActions = require './actions/app-actions.coffee'

Object.assign || (Object.assign = assign)

{ store, history } = createStore()

entities = new XmlEntities()
serverState = document.getElementById('state').textContent
data = JSON.parse entities.decode serverState
params = data.routing.state
store.dispatch appActions.init data
state = store.getState()
store.dispatch ReduxRouter.replacePath state.routing.path, params

init store, params, document.documentElement.lang
  .then ->
    ReactDOM.render Root({ store, history }), document.getElementById 'app'
  .catch (err) ->
    console.error err.stack
