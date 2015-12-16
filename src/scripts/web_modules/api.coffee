Promise = require 'bluebird'
request = require 'superagent'
require('superagent-as-promised')(request)
YAML = require 'js-yaml'

URL = require '../url.coffee'

protocol = 'http://'
host = 'localhost:8081'
server = protocol + host + '/'

getBody = (res) ->
	res.body

module.exports =
	fetchArticles: (params) ->
		request
			.get protocol + host + URL.getPath params
			.accept 'application/json'
			.then getBody
	fetchArticleSchema: ->
		req = request
			.get(server + 'schema/article-schema.yaml')
		if typeof req.buffer == 'function'
			req.buffer()
		req
			.then (res) ->
				if res.ok
					YAML.safeLoad(res.text)
				else
					Promise.reject res.err
	fetchLocaleStrings: (lang) ->
		req = request server + 'locales/' + lang + '.yaml'
		if typeof req.buffer == 'function'
			req.buffer()
		req.then (res) ->
			lang: lang
			data: YAML.safeLoad res.text
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
	saveArticle: (article) ->
		now = (new Date()).toISOString()
		article.created = now unless article.created
		# might add support for drafts/unpublished articles later
		article.published = now unless article.published
		if !article.updated
			article.updated = []
		article.updated[article.updated.length] = now
		request
			.post(server)
			.accept('application/json')
			.send article
	signup: (data) ->
			request
				.post server + 'signup'
				.accept 'application/json'
				.send data
