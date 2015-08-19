expect = require 'expect'

articleActions = require '../src/scripts/actions/article-actions.coffee'

describe 'articleActions', ->
	it 'can create an RECEIVE_ARTICLES action', ->
		articles = [{ _id: '_id' }]
		action =
			type: 'RECEIVE_ARTICLES'
			articles: articles
			lang: 'nb'
			receivedAt: new Date()
		output = articleActions.receiveArticles(articles, 'nb')
		expect(output).toEqual(action)