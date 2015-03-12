moment = require 'moment'
Reflux = require 'reflux'
request = require 'superagent'
actions = require '../actions/article-actions.coffee'

server = 'http://localhost:8081/'

module.exports = Reflux.createStore
	init: ->
		@articles = []
		@lang = 'en'
		@lastFetched = null
		@listenTo actions.fetch, @update
		@listenTo actions.save, @save
	onResponse: (res) ->
		if res.ok
			@lang = res.body.lang
			@articles = (for article in res.body.docs
				do (article) ->
					created = moment(article.created).format('YYYY/MM/DD')
					article.url = '/' + created + '/' + article.slug
					article
			)
			actions.fetch.completed @articles
			@lastFetched = new Date()
			@trigger(@articles)
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
			.end(@onResponse.bind(this))
	fetchAll: ->
		request
			.get(server + 'articlesByMostRecentlyUpdated?descending=true')
			.accept('application/json')
			.end(@onResponse.bind(this))
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
