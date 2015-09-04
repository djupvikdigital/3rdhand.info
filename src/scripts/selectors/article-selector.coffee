utils = require '../utils.coffee'

module.exports = (state) ->
	localeStrings = state.localeState.getIn [ 'localeStrings', 'ArticleEditor' ]
	state = state.articleState
	lang = state.get('lang')
	articles = state.get('articles')
	title = state.getIn ['title', lang]
	if articles.size == 1
		articleTitle = articles.getIn([0, 'title', lang])
		if articleTitle
			articleTitle = utils.getFieldValueFromFormats articleTitle.toJS()
			if articleTitle then title = articleTitle + ' - ' + title
	return {
		title: title
		articles: articles
		defaults: state.get('defaults')
		lang: lang
		localeStrings: localeStrings.toJS()
	}
