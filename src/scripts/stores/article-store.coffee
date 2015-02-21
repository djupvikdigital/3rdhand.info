Reflux = require 'reflux'
actions = require '../actions/article-actions.coffee'

module.exports = Reflux.createStore
	init: ->
		@articles = [
			title: 'Lorem Ipsum'
			content: 'Lorem ipsum dolor sit amet.'
		]
		@listenTo actions.fetch, @update
	update: ->
		@trigger(@articles)