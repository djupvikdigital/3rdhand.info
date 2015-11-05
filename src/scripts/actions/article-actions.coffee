request = require 'superagent-bluebird-promise'
Immutable = require 'immutable'
moment = require 'moment'
t = require 'transducers.js'
int = require 'lodash/string/parseInt'
last = require 'lodash/array/last'
docuri = require 'docuri'

utils = require '../utils.coffee'
API = require '../api.coffee'

protocol = 'http://'
host = 'localhost:8081'
server = protocol + host + '/'

route = docuri.route 'article/:created'

getKey = (slug, date) ->
	dateKey = null
	if date
		if typeof date.toISOString == 'function'
			dateKey = date.toISOString()
		else
			dateKey = date
	if slug
		JSON.stringify [ 'article', slug, dateKey ].filter Boolean
	else if dateKey
		route created: dateKey
	else
		throw new Error('could not construct key')

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

fetch = (params) ->
	query =
		endkey: JSON.stringify [ 'article' ]
		startkey: JSON.stringify [ 'article\uffff' ]
	path = server + 'views/by_updated'
	if params.slug
		path = server + 'views/by_slug_and_date'
		# endkey is earlier than startkey because we use descending order
		query =
			endkey: getKey params.slug
			startkey: getKey params.slug, {}
	if params.year
		dateKeys = [ 'year', 'month', 'day' ]
		dateParams = t.seq(
			utils.getProps params, dateKeys
			utils.mapValues int
		)
		dateParams.month = dateParams.month - 1 if dateParams.month
		date = moment.utc dateParams
		durationKey = last t.filter(
			dateKeys
			Object.prototype.hasOwnProperty.bind dateParams
		)
		if durationKey
			query =
				endkey: getKey params.slug, date
				startkey: getKey params.slug, date.add(1, durationKey)
	query.slug = params.slug if params.slug
	query.descending = true
	request
		.get(path)
		.query(query)
		.accept('application/json')
		.promise()
		.then(onResponse)

requestArticles = (params) ->
	return {
		type: 'REQUEST_ARTICLES'
		params: params
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
			dispatch requestArticles params
			fetch(params).then(dispatch)
	fetchSchema: (params) ->
		(dispatch) ->
			dispatch requestArticleSchema
			API.fetchArticleSchema()
				.then(t.compose dispatch, receiveArticleSchema)
				.catch(t.compose dispatch, receiveArticleSchemaError)
	receiveArticles: receiveArticles
	save: (article) ->
		(dispatch, getState) ->
			now = (new Date()).toISOString()
			article.created = now unless article.created
			# might add support for drafts/unpublished articles later
			article.published = now unless article.published
			if !article.updated
				article.updated = []
			article.updated[article.updated.length] = now
			data = doc: article
			loginState = getState().loginState
			if loginState.get('isLoggedIn')
				data.auth = loginState.filter(
					utils.keyIn 'user', 'password'
				).toJS()
			dispatch requestSave article
			request
				.post(server)
				.accept('application/json')
				.send(data)
				.end (err, res) ->
					dispatch receiveSave err, res
}