expect = require 'expect'

React = require 'react/addons'
TestUtils = React.addons.TestUtils

createComponent = require '../testutils/create-component.coffee'
createStore = require '../testutils/create-store.coffee'
setupState = require '../testutils/setup-state.coffee'
articleActions = require '../src/scripts/actions/article-actions.coffee'
articleSelector = require '../src/scripts/selectors/article-selector.coffee'
ArticleList = require '../src/scripts/views/article-list.coffee'

getArticles = (component) ->
	return component.props.children.props.children

describe 'ArticleList', ->
	it 'renders a list of articles', ->
		store = createStore()
		articles = [
			{ _id: '_id' }
			{ _id: '_id' }		
		]
		store.dispatch {}, setupState()
		store.dispatch articleActions.receiveArticles(articles)
		props = articleSelector(store.getState())
		props.dispatch = (action) ->
			console.log action
			return
		output = createComponent(ArticleList, props)
		articles = getArticles(output)
		expect(articles.length).toBe(2)
