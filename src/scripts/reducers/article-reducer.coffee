Immutable = require 'immutable'
defaults = require 'json-schema-defaults'

initialState = Immutable.fromJS({
	title:
		nb: '3rdhand.info'
		en: '3rdhand.info'
	articles: []
	error: null
	refetch: false
})

reducers =
	FETCH_ARTICLE_SCHEMA_FULFILLED: (state, payload) ->
		state.merge defaults: defaults payload
	FETCH_ARTICLES_FULFILLED: (state, payload) ->
		state.merge
			articles: payload.docs
			error: null
			lastUpdate: new Date()
			refetch: false
	FETCH_ARTICLES_REJECTED: (state, payload) ->
		state.merge Immutable.Map
			articles: Immutable.List()
			error: payload
			lastUpdate: null
	LOGIN_FULFILLED: (state) ->
		err = state.get 'error'
		if err?.status == 404
			return state.set 'refetch', true
		else
			return state
	INIT: (state, payload) ->
		state.merge payload.state.articleState

module.exports = (state = initialState, action) ->
	if typeof reducers[action.type] == 'function'
		reducers[action.type](state, action.payload)
	else
		return state
