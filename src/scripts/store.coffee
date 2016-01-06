Redux = require 'redux'
promiseMiddleware = require 'redux-promise-middleware'
thunkMiddleware = require 'redux-thunk'
Router = require 'react-router'
createHistory = require 'history/lib/createMemoryHistory' # aliased in webpack
ReduxRouter = require 'redux-simple-router'
{ devTools } = require 'redux-devtools'

routes = require './views/routes.coffee'

reducer = Redux.combineReducers
	articleState: require './reducers/article-reducer.coffee'
	localeState: require './reducers/locale-reducer.coffee'
	loginState: require './reducers/login-reducer.coffee'
	routing: ReduxRouter.routeReducer

store = Redux.compose(
	Redux.applyMiddleware promiseMiddleware(), thunkMiddleware
	devTools()
)(Redux.createStore)(reducer)

history = createHistory()

ReduxRouter.syncReduxAndRouter history, store

module.exports = { store, history }
