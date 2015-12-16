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

module.exports = (state = initialState, action) ->
	switch action.type
		when 'FETCH_ARTICLE_SCHEMA_FULFILLED'
			return state.merge({
				defaults: defaults(action.payload)
			})
		when 'FETCH_ARTICLES_FULFILLED'
			return state.merge({
				articles: action.payload.docs
				error: null
				lastUpdate: new Date()
				refetch: false
			})
		when 'FETCH_ARTICLES_REJECTED'
			return state.merge Immutable.Map
				articles: Immutable.List()
				error: action.payload
				lastUpdate: null
		when 'LOGIN_FULFILLED'
			err = state.get 'error'
			if err?.status == 404
				return state.set 'refetch', true
			else
				return state
		else
			return state