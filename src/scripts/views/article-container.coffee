Immutable = require 'immutable'
React = require 'react'
ReactRedux = require 'react-redux'

utils = require '../utils.coffee'
createFactory = require '../create-factory.coffee'

articleActions = require '../actions/article-actions.coffee'
selectors = require '../selectors/article-selectors.coffee'
store = require '../store.coffee'
ArticleList = createFactory(
	ReactRedux.connect(selectors.listSelector)(
		require './article-list.coffee'
	)
)
ArticleItem = createFactory(
	ReactRedux.connect(selectors.itemSelector)(require './article.coffee')
)
ArticleEditor = createFactory(
	ReactRedux.connect(selectors.editorSelector)(
		require './article-editor.coffee'
	)
)

module.exports = React.createClass
	displayName: 'ArticleContainer'
	fetch: (params) ->
		@props.dispatch articleActions.fetch(params)
	save: (data) ->
		@props.dispatch articleActions.save data
 	componentWillMount: ->
 		@fetch @props.params unless @props.lastUpdate
	componentWillReceiveProps: (nextProps) ->
		if nextProps.params != @props.params
			@fetch nextProps.params
	render: ->
		articles = @props.articles
		unless articles.length <= 1
			ArticleList articles: articles, lang: @props.lang
		else if @props.params?.view
			ArticleEditor save: @save, params: @props.params
		else
			ArticleItem()
