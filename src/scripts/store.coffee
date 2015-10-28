Redux = require 'redux'
thunkMiddleware = require 'redux-thunk'
ReduxRouter = require 'redux-router'
History = require 'history'
{ devTools } = require 'redux-devtools'

routes = require './views/routes.coffee'

reducer = Redux.combineReducers
	articleState: require './reducers/article-reducer.coffee'
	localeState: require './reducers/locale-reducer.coffee'
	loginState: require './reducers/login-reducer.coffee'
	router: ReduxRouter.routerStateReducer

if typeof window != 'undefined'
	createHistory = History.createHistory
else
	createHistory = History.createMemoryHistory

store = Redux.compose(
	Redux.applyMiddleware thunkMiddleware
	ReduxRouter.reduxReactRouter { routes, createHistory }
	devTools()
)(Redux.createStore)(reducer)

module.exports = store
