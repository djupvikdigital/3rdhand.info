API = require 'api'

module.exports =
	fetch: (params) ->
		type: 'FETCH_ARTICLES'
		payload:
			promise: API.fetchArticles params
			data: { params }
# 	receiveArticles: receiveArticles TODO: rewrite tests to not use this
	save: (article, userId) ->
		type: 'SAVE_ARTICLE'
		payload:
			promise: API.saveArticle article, userId
			data: { article }
