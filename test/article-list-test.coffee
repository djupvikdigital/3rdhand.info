expect = require 'expect'

React = require 'react'
ReactDOM = require 'react-dom/server'
ReactRedux = require 'react-redux'
cheerio = require 'cheerio'

createFactory = require '../src/scripts/create-factory.coffee'

createStore = require '../src/scripts/store.coffee'
selectors = require '../src/scripts/selectors/article-selectors.coffee'
ArticleList = createFactory require '../src/scripts/views/article-list.coffee'

Provider = createFactory ReactRedux.Provider

describe 'ArticleList', ->
	it 'renders a list of articles', ->
		{ store } = createStore()
		articles = [
			{ _id: '_id1' }
			{ _id: '_id2' }		
		]
		store.dispatch
			type: 'FETCH_ARTICLES_FULFILLED'
			payload: 
				docs: articles
		props = selectors.containerSelector(store.getState())
		component = Provider(
			store: store
			ArticleList props
		)
		html = ReactDOM.renderToStaticMarkup component
		$ = cheerio.load html
		articles = $ 'article'
		expect(articles.length).toBe 2
