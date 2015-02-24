React = require 'react'
Reflux = require 'reflux'
articleActions = require '../actions/article-actions.coffee'
articleStore = require '../stores/article-store.coffee'
ArticleItem = require './article.cjsx'

module.exports = React.createClass
	displayName: 'ArticleList'
	mixins: [
		Reflux.listenTo(articleStore, 'onUpdate')
	]
	fetch: (params) ->
		if params.slug
			articleActions.fetchOne(params)
		else
			articleActions.fetch()
	onUpdate: (articles) ->
		@setState articles: articles
	getInitialState: ->
		@fetch @props.params
		{ articles: [] }
	componentWillReceiveProps: (nextProps) ->
		@fetch nextProps.params
	render: ->
		articles = (<ArticleItem key={ article._id } data={ article }/> for article in @state.articles)
		<div>
			{ articles }
		</div>
