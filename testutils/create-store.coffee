Redux = require 'redux'
thunkMiddleware = require 'redux-thunk'

reducer = Redux.combineReducers
	articleState: require '../src/scripts/reducers/article-reducer.coffee'
	loginState: require '../src/scripts/reducers/login-reducer.coffee'

createStore = Redux.applyMiddleware(thunkMiddleware)(Redux.createStore)

module.exports = ->
	createStore reducer