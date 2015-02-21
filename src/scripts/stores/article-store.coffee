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
				@articles = res.body.rows.map (row) ->
					row.value
				actions.fetch.completed res.body
				@trigger(@articles)
			else
				actions.fetch.failed res.error
