Immutable = require 'immutable'
moment = require 'moment'
Reselect = require 'reselect'

utils = require '../utils.coffee'
formatters = require '../formatters.coffee'
appSelectors = require './app-selectors.coffee'

formatSelector = (state) ->
	lang = state.lang
	moment.locale lang
	utils.mapObjectRecursively(
		state
		[ lang, utils.identity ]
 		[ 'format', 'text', utils.createFormatMapper(formatters) ]
 		[ 'slug', utils.hrefMapper ]
		[ 
			'published'
			utils.createPropertyMapper 'publishedFormatted', (published) ->
				moment(published).format('LLL')
		]
	)

articleSelector = (state) ->
	lang = state.localeState.get 'lang'
	state = state.articleState.toJS()
	if state.articles.length
		article = state.articles[0]
	else
		article = state.defaults
	return {
		article: article
		lang: lang
	}

itemSelector = Reselect.createSelector(
	[
		Reselect.createSelector [ articleSelector ], formatSelector
		appSelectors.titleSelector
	]
	(state, titleState) ->
		title = titleState.title
		if state.article
			articleTitle = state.article.title
			if articleTitle
				title = articleTitle + ' - ' + title
		state.title = title
		state
)

module.exports =
	containerSelector: Reselect.createSelector(
		[
			(state) ->
				return {
					lang: state.localeState.get 'lang'
					articles: state.articleState.get('articles').toJS()
				}
		],
		formatSelector
	)
	itemSelector: itemSelector
	editorSelector: Reselect.createSelector(
		[
			articleSelector
			itemSelector
			appSelectors.loginSelector
			appSelectors.localeSelector
			(state) ->
				state.articleState.get('defaults').toJS()
		]
		(state, item, loginState, localeState, defaults) ->
			Immutable.Map(state).merge(
				Immutable.Map(
					defaults: defaults
					title: item.title
					loginState: loginState
					localeStrings: localeState.localeStrings.ArticleEditor
				)
			).toObject()
	)
