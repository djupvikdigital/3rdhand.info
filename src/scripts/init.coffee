Promise = require 'bluebird'

store = require './store.coffee'
articleActions = require './actions/article-actions.coffee'
localeActions = require './actions/locale-actions.coffee'

module.exports = (params) ->
	store.dispatch(articleActions.fetchSchema()).then ->
		Promise.all([
			store.dispatch localeActions.fetchStrings(store.getState().localeState.get('lang'))
			store.dispatch articleActions.fetch(params)
		])