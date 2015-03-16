Reflux = require 'reflux'
Promise = 'bluebird'
request = require 'superagent-bluebird-promise'
YAML = require 'js-yaml'
defaults = require 'json-schema-defaults'

actions = require '../actions/article-actions.coffee'
loginStore = require './login-store.coffee'

protocol = 'http://'
host = 'localhost:8081'
server = protocol + host + '/'

module.exports = Reflux.createStore
	init: ->
		@articles = []
		@lang = 'en'
		@lastFetched = null
		@listenTo actions.fetch, @update
		@listenTo actions.save, @save
	create: ->
		if @articleDefault
			return Promise.resolve @articleDefault
		req = request
			.get(server + 'schema/article-schema.yaml')
		if typeof req.buffer == 'function'
			req.buffer()
		req
			.promise()
			.then (res) ->
				if res.ok
					schema = YAML.safeLoad(res.text)
					@articleDefault = defaults(schema)
	set: (articles) ->
		if Object.prototype.toString.call(articles) == '[object Array]'
			@articles = articles
		else
			@articles = Array.prototype.slice.call(arguments)
		actions.fetch.completed @articles
		@lastFetched = new Date()
		@trigger(@articles)
		@articles
	onResponse: (res) ->
		if res.ok
			@lang = res.body.lang
			articles = res.body.docs
			if !articles.length
				@create().then(@set)
			else
				@set(articles)
		else
			actions.fetch.failed res.error
	fetchOne: (params) ->
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
			.bind(this)
			.then(@onResponse)
	fetchAll: ->
		request
			.get(server + 'articlesByMostRecentlyUpdated?descending=true')
			.accept('application/json')
			.promise()
			.bind(this)
			.then(@onResponse)
	update: (params) ->
		if params.slug
			@fetchOne params
		else
			@fetchAll()
	save: (article) ->
		now = (new Date()).toISOString()
		article.created = now unless article.created
		article.updated = now
		data = doc: article
		if loginStore.isLoggedIn()
			data.auth = loginStore.getLogin()
		request.post(server).send(data).end (res) ->
			if res.ok
				actions.save.completed res.body
			else
				actions.save.failed res.error
