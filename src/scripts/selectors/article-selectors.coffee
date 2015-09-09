Immutable = require 'immutable'
moment = require 'moment'
Reselect = require 'reselect'

utils = require '../utils.coffee'
formatters = require '../formatters.coffee'
appSelectors = require './app-selectors.coffee'

formatSelector = (state) ->
	lang = state.lang
	utils.mapObjectRecursively(
		state
		[ lang, utils.identity ]
 		[ 'format', 'text', utils.createFormatMapper(formatters) ]
 		[ 'slug', utils.hrefMapper ]
		[ 
			'published'
			utils.createPropertyMapper 'publishedFormatted', (published) ->
				moment(published).format('YYYY-MM-DD HH:mm:ss')
		]
	)

itemSelector = (state) ->
	state = state.articleState.toJS()
	if state.articles.length
		article = state.articles[0]
	else
		article = state.defaults
	return {
		article: article
		lang: state.lang
	}

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
	itemSelector: Reselect.createSelector(
		[
			Reselect.createSelector [ itemSelector ], formatSelector
			appSelectors.titleSelector
		]
		(state, titleState) ->
			title = titleState.title
			articleTitle = state.article.title
			if articleTitle
				title = articleTitle + ' - ' + title
			state.title = title
			state
	)
	editorSelector: Reselect.createSelector(
		[
			itemSelector
			appSelectors.localeSelector
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
