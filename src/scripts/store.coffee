Redux = require 'redux'
promiseMiddleware = require('redux-promise-middleware').default
thunkMiddleware = require('redux-thunk').default
Router = require 'react-router'
ReduxRouter = require 'react-router-redux'

actions = require './actions/appActions.js'
routes = require './views/routes.coffee'
utils = require './utils.coffee'

reducer = Redux.combineReducers
  appState: require './reducers/appReducer.js'
  articleState: require './reducers/articleReducer.js'
  localeState: require './reducers/locale-reducer.coffee'
  loginState: require './reducers/login-reducer.coffee'
  routing: ReduxRouter.routerReducer

isBrowser = typeof window == 'object'
hasDevTools = isBrowser && typeof window.devToolsExtension != 'undefined'

module.exports = (_history, data) ->
  store = Redux.compose(
    Redux.applyMiddleware(
      promiseMiddleware()
      thunkMiddleware
      ReduxRouter.routerMiddleware _history
    )
    if hasDevTools then window.devToolsExtension() else utils.identity
  )(Redux.createStore)(reducer)
  if data
    store.dispatch actions.init data
  history = ReduxRouter.syncHistoryWithStore _history, store
  return { store, history }
