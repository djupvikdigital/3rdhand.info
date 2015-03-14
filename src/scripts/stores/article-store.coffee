moment = require 'moment'
Reflux = require 'reflux'
Promise = 'bluebird'
request = require 'superagent-bluebird-promise'
YAML = require 'js-yaml'
defaults = require 'json-schema-defaults'
actions = require '../actions/article-actions.coffee'

server = 'http://localhost:8081/'

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
		if Object.prototype.toString.call(articles) != '[object Array]'
			articles = Array.prototype.slice.call(arguments)
		@articles = (for article in articles
			do (article) ->
				created = moment(article.created).format('YYYY/MM/DD')
				article.url = '/' + created + '/' + article.slug
				article
		)
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
		request.post(server).send(article).end (res) ->
			if res.ok
				actions.save.completed res.body
			else
				actions.save.failed res.error
