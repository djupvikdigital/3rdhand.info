Redux = require 'redux'
promiseMiddleware = require 'redux-promise-middleware'
thunkMiddleware = require 'redux-thunk'
ReduxRouter = require 'redux-router'
createHistory = require 'history/lib/createMemoryHistory' # aliased in webpack
{ devTools } = require 'redux-devtools'

routes = require './views/routes.coffee'

reducer = Redux.combineReducers
	articleState: require './reducers/article-reducer.coffee'
	localeState: require './reducers/locale-reducer.coffee'
	loginState: require './reducers/login-reducer.coffee'
	router: ReduxRouter.routerStateReducer

store = Redux.compose(
	Redux.applyMiddleware promiseMiddleware()
	Redux.applyMiddleware thunkMiddleware
	ReduxRouter.reduxReactRouter { routes, createHistory }
	devTools()
)(Redux.createStore)(reducer)

module.exports = store
