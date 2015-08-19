utils = require '../utils.coffee'

module.exports = (state) ->
	state = state.articleState
	lang = state.get('lang')
	articles = state.get('articles')
	title = state.getIn ['title', lang]
	if articles.size == 1
		articleTitle = utils.getFieldValueFromFormats(
			articles.getIn([0, 'title', lang]).toJS()
		)
		if articleTitle
			title = articleTitle + ' - ' + title
	return {
		title: title
		articles: articles
		lang: lang
	}
