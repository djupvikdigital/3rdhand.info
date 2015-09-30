Promise = require 'bluebird'

store = require './store.coffee'
articleActions = require './actions/article-actions.coffee'
localeActions = require './actions/locale-actions.coffee'

module.exports = (params, lang) ->
	store.dispatch(articleActions.fetchSchema()).then ->
		Promise.all([
			store.dispatch localeActions.fetchStrings(lang)
			store.dispatch articleActions.fetch(params)
		]).catch (err) ->
			console.log err