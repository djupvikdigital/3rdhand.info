moment = require 'moment'
Reflux = require 'reflux'
request = require 'superagent'
actions = require '../actions/article-actions.coffee'

module.exports = Reflux.createStore
	init: ->
		@articles = []
		@listenTo actions.fetch, @update
	update: ->
		request 'http://localhost:8081/blog', (res) =>
			if res.ok
				@articles = (for row in res.body.rows
					do (row) ->
						article = row.value
						created = moment(article.created).format('YYYY/MM/DD')
						article.url = '/' + created + '/' + article.slug
						article
				)
				actions.fetch.completed res.body
				@trigger(@articles)
			else
				actions.fetch.failed res.error
