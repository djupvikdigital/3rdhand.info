Immutable = require 'immutable'
defaults = require 'json-schema-defaults'

initialState = Immutable.fromJS({
	title:
		nb: '3rdhand.info'
		en: '3rdhand.info'
	lang: 'nb'
	articles: []
})

module.exports = (state = initialState, action) ->
	switch action.type
		when 'RECEIVE_ARTICLE_SCHEMA_SUCCESS'
			return state.merge({
				defaults: defaults(action.schema)
			})
		when 'RECEIVE_ARTICLES'
			return state.merge({
				articles: action.articles
				lang: if action.lang then action.lang else state.get 'lang'
				lastUpdate: action.receivedAt
			})
		else
			return state