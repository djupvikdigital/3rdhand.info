React = require 'react'
ReactRedux = require 'react-redux'

createFactory = require '../create-factory.coffee'

actions = require '../actions/article-actions.coffee'
selectors = require '../selectors/article-selectors.coffee'

ArticleList = createFactory(
	ReactRedux.connect(selectors.listSelector)(
		require './article-list.coffee'
	)
)
ArticleFull = createFactory(
	ReactRedux.connect(selectors.itemSelector)(require './article-full.coffee')
)
ArticleEditor = createFactory(
	ReactRedux.connect(selectors.editorSelector)(
		require './article-editor.coffee'
	)
)

module.exports = React.createClass
	displayName: 'ArticleContainer'
	fetch: (params) ->
		@props.dispatch actions.fetch(params)
	save: (data) ->
		@props.dispatch actions.save data
 	componentWillMount: ->
 		@fetch @props.params unless @props.lastUpdate
	componentWillReceiveProps: (nextProps) ->
		if nextProps.params != @props.params
			@fetch nextProps.params
	render: ->
		articles = @props.articles
		if articles.length > 1
			ArticleList articles: articles, lang: @props.lang
		else if @props.params?.view
			ArticleEditor save: @save, params: @props.params
		else
			ArticleFull()
