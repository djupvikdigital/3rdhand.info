moment = require 'moment'
Reflux = require 'reflux'
request = require 'superagent'
actions = require '../actions/article-actions.coffee'

server = 'http://localhost:8081/'

module.exports = Reflux.createStore
	init: ->
		@articles = []
		@listenTo actions.fetch, @update
		@listenTo actions.fetchOne, @fetchOne
	onResponse: (res) ->
		if res.ok
			@articles = (for article in res.body
				do (article) ->
					created = moment(article.created).format('YYYY/MM/DD')
					article.url = '/' + created + '/' + article.slug
					article
			)
			actions.fetch.completed res.body
			@trigger(@articles)
		else
			actions.fetch.failed res.error
	fetchOne: (params) ->
		# TODO: validate params as numbers
		date = new Date(params.year, params.month - 1, params.day)
		key = [ date.toDateString(), params.slug ]
		request
			.get(server + 'articlesByDateAndSlug?key=' + JSON.stringify(key))
			.accept('application/json')
			.end(@onResponse.bind(this))
	update: ->
		request
			.get(server + 'articlesByMostRecentlyUpdated?descending=true')
			.accept('application/json')
			.end(@onResponse.bind(this))
