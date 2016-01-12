request = require 'superagent'
require('superagent-as-promised')(request, Promise)
defaults = require 'json-schema-defaults'

articleSchema = require '../../../schema/article-schema.yaml'
URL = require '../url.coffee'

protocol = 'http://'
host = 'localhost:8081'
server = protocol + host + '/'

articleDefaults = defaults articleSchema

getBody = (res) ->
	res.body

module.exports =
	fetchArticles: (params) ->
		request
			.get protocol + host + URL.getPath params
			.accept 'application/json'
			.then getBody
	fetchLocaleStrings: (lang) ->
		request server + 'locales/' + lang
			.accept 'application/json'
			.then getBody
	getArticleDefaults: ->
		Object.assign {}, articleDefaults
	login: (data) ->
		request
			.post server + 'users'
			.accept 'application/json'
			.send data
			.then getBody
	logout: (userId) ->
		request
			.get protocol + host + URL.getUserPath(userId) + '/logout'
			.accept 'application/json'
	saveArticle: (article, userId) ->
		now = (new Date()).toISOString()
		article.created = now unless article.created
		# might add support for drafts/unpublished articles later
		article.published = now unless article.published
		if !article.updated
			article.updated = []
		article.updated[article.updated.length] = now
		request
			.post protocol + host + URL.getUserPath userId
			.accept 'application/json'
			.send article
	signup: (data) ->
			request
				.post server + 'signup'
				.accept 'application/json'
				.send data
