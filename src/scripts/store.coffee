Redux = require 'redux'
thunkMiddleware = require 'redux-thunk'

reducer = Redux.combineReducers
	articleState: require './reducers/article-reducer.coffee'
	localeState: require './reducers/locale-reducer.coffee'
	loginState: require './reducers/login-reducer.coffee'

createStore = Redux.applyMiddleware(thunkMiddleware)(Redux.createStore)

module.exports = createStore reducer