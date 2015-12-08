API = require '../api.coffee'
URL = require '../url.coffee'

module.exports =
	fetch: (params) ->
		type: 'FETCH_ARTICLES'
		payload:
			promise: API.fetchArticles URL.getPath params
			data: { params }
	fetchSchema: (params) ->
		type: 'FETCH_SCHEMA'
		payload:
			promise: API.fetchArticleSchema()
# 	receiveArticles: receiveArticles
	save: (article) ->
		type: 'SAVE_ARTICLE'
		payload:
			promise: API.saveArticle article
			data: { article }
