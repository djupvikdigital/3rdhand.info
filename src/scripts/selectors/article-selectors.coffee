Immutable = require 'immutable'
moment = require 'moment'
Reselect = require 'reselect'

utils = require '../utils.coffee'
formatters = require '../formatters.coffee'
API = require 'api'
appSelectors = require './app-selectors.coffee'

langSelector = (state) ->
	state.localeState.get 'lang'

formatSelector = (state, lang) ->
	moment.locale lang
	utils.mapObjectRecursively(
		state
		[ lang, utils.identity ]
		[ 'format', 'text', utils.createFormatMapper(formatters) ]
		[ 
			'published'
			utils.createPropertyMapper 'publishedFormatted', (published) ->
				moment(published).format('LLL')
		]
	)

containerSelector = Reselect.createSelector(
	[
		(state) ->
			state.articleState.toJS()
		langSelector
	],
	formatSelector
)

articleSelector = (state) ->
	state = state.articleState.toJS()
	if state.articles.length
		article = state.articles[0]
	else
		article = API.getArticleDefaults()
	return {
		article: article
	}

itemSelector = Reselect.createSelector(
	[
		Reselect.createSelector(
			[ articleSelector, langSelector ]
			formatSelector
		)
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
			containerSelector
			appSelectors.paramSelector
		]
		(state, params) ->
			state.params = params
			state
	)
	itemSelector: itemSelector
	editorSelector: Reselect.createSelector(
		[
			articleSelector
			itemSelector
			langSelector
			appSelectors.localeSelector
		]
		(state, item, lang, localeStrings) ->
			Object.assign {}, state, {
				title: item.title
				lang: lang
				localeStrings: localeStrings.ArticleEditor
			}
	)
