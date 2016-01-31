Redux = require 'redux'
promiseMiddleware = require 'redux-promise-middleware'
thunkMiddleware = require 'redux-thunk'
Router = require 'react-router'
createHistory = require 'history/lib/createMemoryHistory' # aliased in webpack
ReduxRouter = require 'redux-simple-router'

routes = require './views/routes.coffee'
utils = require './utils.coffee'

reducer = Redux.combineReducers
  articleState: require './reducers/article-reducer.coffee'
  localeState: require './reducers/locale-reducer.coffee'
  loginState: require './reducers/login-reducer.coffee'
  routing: ReduxRouter.routeReducer

hasDevTools = (
  typeof window == 'object' && typeof window.devToolsExtension != 'undefined'
)

module.exports = ->
  store = Redux.compose(
    Redux.applyMiddleware promiseMiddleware(), thunkMiddleware
    if hasDevTools then window.devToolsExtension() else utils.identity
  )(Redux.createStore)(reducer)
  history = createHistory()
  ReduxRouter.syncReduxAndRouter history, store
  return { store, history }
