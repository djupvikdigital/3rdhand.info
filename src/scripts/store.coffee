Redux = require 'redux'
promiseMiddleware = require 'redux-promise-middleware'
thunkMiddleware = require 'redux-thunk'
Router = require 'react-router'
createHistory = require 'history/lib/createMemoryHistory' # aliased in webpack
ReduxRouter = require 'redux-simple-router'

routes = require './views/routes.coffee'

reducer = Redux.combineReducers
	articleState: require './reducers/article-reducer.coffee'
	localeState: require './reducers/locale-reducer.coffee'
	loginState: require './reducers/login-reducer.coffee'
	routing: ReduxRouter.routeReducer

module.exports = ->
	store = Redux.applyMiddleware(
		promiseMiddleware()
		thunkMiddleware
	)(Redux.createStore)(reducer)
	history = createHistory()
	ReduxRouter.syncReduxAndRouter history, store
	return { store, history }
