React = require 'react'
ReactRedux = require 'react-redux'

createFactory = require '../create-factory.coffee'

actions = require '../actions/article-actions.coffee'
selectors = require '../selectors/article-selectors.coffee'

ArticleList = createFactory require './article-list.coffee'
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
 		@fetch @props.urlParams unless @props.lastUpdate
	componentWillReceiveProps: (nextProps) ->
		if nextProps.urlParams != @props.urlParams
			@fetch nextProps.urlParams
	render: ->
		params = @props.urlParams || {}
		articles = @props.articles
		if articles.length > 1
			ArticleList articles: articles
		else if params.view
			ArticleEditor save: @save, params: params
		else
			ArticleFull()
