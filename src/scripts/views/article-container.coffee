React = require 'react'
ReactRedux = require 'react-redux'
Immutable = require 'immutable'

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
 		@fetch @props.params unless @props.lastUpdate
	componentWillReceiveProps: (nextProps) ->
		nextParams = Immutable.Map nextProps.params
		params = Immutable.Map @props.params
		if nextProps.refetch || !Immutable.is nextParams, params 
			@fetch nextProps.params
	render: ->
		params = @props.params || {}
		articles = @props.articles
		if articles.length > 1
			ArticleList articles: articles
		else if params.view
			ArticleEditor save: @save, params: params
		else
			ArticleFull()
