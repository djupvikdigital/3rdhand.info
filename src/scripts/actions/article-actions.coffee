API = require 'api'

module.exports =
	fetch: (params) ->
		type: 'FETCH_ARTICLES'
		payload:
			promise: API.fetchArticles params
			data: { params }
	fetchSchema: (params) ->
		type: 'FETCH_SCHEMA'
		payload:
			promise: API.fetchArticleSchema()
# 	receiveArticles: receiveArticles
	save: (article, userId) ->
		type: 'SAVE_ARTICLE'
		payload:
			promise: API.saveArticle article, userId
			data: { article }
