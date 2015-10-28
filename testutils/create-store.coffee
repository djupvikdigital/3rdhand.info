Redux = require 'redux'
thunkMiddleware = require 'redux-thunk'
ReduxRouter = require 'redux-router'
createHistory = require 'history/lib/createMemoryHistory'

routes = require '../src/scripts/views/routes.coffee'

reducer = Redux.combineReducers
	articleState: require '../src/scripts/reducers/article-reducer.coffee'
	loginState: require '../src/scripts/reducers/login-reducer.coffee'
	localeState: require '../src/scripts/reducers/locale-reducer.coffee'
	router: ReduxRouter.routerStateReducer

createStore = Redux.compose(
	Redux.applyMiddleware(thunkMiddleware)
	ReduxRouter.reduxReactRouter { routes, createHistory }
)(Redux.createStore)

module.exports = ->
	createStore reducer