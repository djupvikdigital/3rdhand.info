expect = require 'expect'

React = require 'react'
ReactDOM = require 'react-dom/server'
ReactRedux = require 'react-redux'
cheerio = require 'cheerio'

createFactory = require '../src/scripts/create-factory.coffee'

createStore = require '../testutils/create-store.coffee'
setupState = require '../testutils/setup-state.coffee'
articleActions = require '../src/scripts/actions/article-actions.coffee'
selectors = require '../src/scripts/selectors/article-selectors.coffee'
ArticleList = createFactory require '../src/scripts/views/article-list.coffee'

Provider = createFactory ReactRedux.Provider

describe 'ArticleList', ->
	it 'renders a list of articles', ->
		store = createStore()
		articles = [
			{ _id: '_id1' }
			{ _id: '_id2' }		
		]
		store.dispatch { type: 'INIT' }, setupState()
		store.dispatch articleActions.receiveArticles(articles)
		props = selectors.containerSelector(store.getState())
		component = Provider(
			store: store
			ArticleList props
		)
		html = ReactDOM.renderToStaticMarkup component
		$ = cheerio.load html
		articles = $ 'article'
		expect(articles.length).toBe 2
