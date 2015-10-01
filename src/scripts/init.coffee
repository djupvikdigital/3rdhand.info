Promise = require 'bluebird'

store = require './store.coffee'
navigationActions = require './actions/navigation-actions.coffee'
articleActions = require './actions/article-actions.coffee'
localeActions = require './actions/locale-actions.coffee'

module.exports = (params, lang) ->
	store.dispatch navigationActions.setParams params
	store.dispatch(articleActions.fetchSchema()).then ->
		Promise.all([
			store.dispatch localeActions.fetchStrings(lang)
			store.dispatch articleActions.fetch(params)
		]).catch (err) ->
			console.log err