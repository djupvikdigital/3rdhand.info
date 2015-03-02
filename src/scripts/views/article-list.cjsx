React = require 'react'
Reflux = require 'reflux'
DocumentTitle = require 'react-document-title'

articleActions = require '../actions/article-actions.coffee'
articleStore = require '../stores/article-store.coffee'
ArticleItem = require './article.cjsx'

module.exports = React.createClass
	displayName: 'ArticleList'
	mixins: [
		Reflux.listenTo(articleStore, 'onUpdate')
	]
	fetch: (params) ->
		articleActions.fetch(params)
	onUpdate: (articles) ->
		@setState articles: articles
	getInitialState: ->
		@fetch @props.params unless articleStore.lastFetched
		{ articles: articleStore.articles }
	componentWillReceiveProps: (nextProps) ->
		@fetch nextProps.params
	render: ->
		articles = @state.articles
		title = if articles.length == 1 then articles[0].title else @props.title
		list = (<ArticleItem key={ article._id } data={ article }/> for article in articles)
		<DocumentTitle title={ title }>
			<div>
				{ list }
			</div>
		</DocumentTitle>
