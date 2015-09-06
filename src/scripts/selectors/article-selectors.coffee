Immutable = require 'immutable'
Reselect = require 'reselect'

utils = require '../utils.coffee'
formatters = require '../formatters.coffee'
localeSelector = require './locale-selector.coffee'

itemSelector = (state) ->
	state = state.articleState.toJS()
	lang = state.lang
	title = state.title[lang]
	if state.articles.length
		article = state.articles[0]
	else
		article = state.defaults
	articleTitle = article.title[lang]
	if articleTitle
		articleTitle = utils.getFieldValueFromFormats articleTitle
		if articleTitle then title = articleTitle + ' - ' + title
	return {
		title: title
		article: article
		lang: state.lang
	}

formatSelector = (state) ->
	lang = state.lang
	utils.localize lang, utils.format state, formatters

module.exports =
	containerSelector: Reselect.createSelector(
		[
			(state) ->
				state.articleState.filter(
					utils.keyIn('articles', 'lang')
				).toJS()
		],
		formatSelector
	)
	itemSelector: Reselect.createSelector [ itemSelector ], formatSelector
	editorSelector: Reselect.createSelector(
		[
			itemSelector
			localeSelector
			(state) ->
				state.articleState.get('defaults').toJS()
		]
		(state, localeState, defaults) ->
			Immutable.Map(state).merge(
				Immutable.Map(
					defaults: defaults
					localeStrings: localeState.localeStrings.ArticleEditor
				)
			).toObject()
	)
