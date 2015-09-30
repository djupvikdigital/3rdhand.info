request = require 'superagent-bluebird-promise'

API = require '../api.coffee'
store = require '../store.coffee'

protocol = 'http://'
host = 'localhost:8081'
server = protocol + host + '/views/'

receiveArticles = (articles, lang) ->
	if Object.prototype.toString.call(articles) != '[object Array]'
		articles = Array.prototype.slice.call(arguments)
	return {
		type: 'RECEIVE_ARTICLES'
		articles: articles
		lang: lang
		receivedAt: new Date()
	}

onResponse = (res) ->
	if res.ok && res.body.docs
		articles = res.body.docs
		receiveArticles(articles, res.body.lang)
	else
		return {
			type: 'RECEIVE_ARTICLES_ERROR'
			error: res.error
		}

fetchOne = (params) ->
	# TODO: validate params as numbers
	date = new Date(params.year, params.month - 1, params.day)
	query = {
		key: JSON.stringify [ date.toDateString(), params.slug ]
	}
	query.view = params.view if params.view
	request
		.get(server + 'articlesByDateAndSlug')
		.query(query)
		.accept('application/json')
		.promise()
		.then(onResponse)

fetchAll = ->
	request
		.get(server + 'articlesByMostRecentlyUpdated?descending=true')
		.accept('application/json')
		.promise()
		.then(onResponse)

requestArticles = (one) ->
	return {
		type: 'REQUEST_ARTICLES'
		one: one
	}

requestSave = (article) ->
	return {
		type: 'REQUEST_SAVE_ARTICLE'
		article: article
	}

receiveSave = (err, res) ->
	if res && res.ok
		return {
			type: 'RECEIVE_SAVE_SUCCESS'
			body: res.body
		}
	else
		return {
			type: 'RECEIVE_SAVE_ERROR'
			response: res
			error: err
		}

requestArticleSchema = ->
	return {
		type: 'REQUEST_ARTICLE_SCHEMA'
	}

receiveArticleSchema = (schema) ->
	return {
		type: 'RECEIVE_ARTICLE_SCHEMA_SUCCESS'
		schema: schema
		receivedAt: new Date()
	}

receiveArticleSchemaError = (err) ->
	return {
		type: 'RECEIVE_ARTICLE_SCHEMA_ERROR'
		error: err
	}

module.exports = {
	fetch: (params) ->
		(dispatch) ->
			if params?.slug
				dispatch requestArticles(true)
				fetchOne(params).then(dispatch)
			else
				dispatch requestArticles(false)
				fetchAll().then(dispatch)
	fetchSchema: (params) ->
		(dispatch) ->
			dispatch requestArticleSchema
			API.fetchArticleSchema()
				.then(receiveArticleSchema)
				.catch(receiveArticleSchemaError)
				.then(dispatch)
	receiveArticles: receiveArticles
	save: (article) ->
		(dispatch) ->
			now = (new Date()).toISOString()
			article.created = now unless article.created
			# might add support for drafts/unpublished articles later
			article.published = now unless article.published
			article.updated = now
			data = doc: article
			loginState = store.getState().loginState
			if loginState.get('isLoggedIn')
				data.auth = loginState.filter((v, k) ->
					if k == 'user' || k == 'password'
						true
					else
						false
				).toJS()
			dispatch requestSave article
			request
				.post(server)
				.accept('application/json')
				.send(data)
				.end (err, res) ->
					dispatch receiveSave err, res
}