Promise = require 'bluebird'

store = require './store.coffee'
articleActions = require './actions/article-actions.coffee'
localeActions = require './actions/locale-actions.coffee'

module.exports = (params, lang) ->
	store.dispatch(articleActions.fetchSchema()).payload.promise.then ->
		Promise.all([
			store.dispatch(localeActions.fetchStrings lang).payload.promise
			store.dispatch(articleActions.fetch params).payload.promise
		]).catch (err) ->
			console.log err