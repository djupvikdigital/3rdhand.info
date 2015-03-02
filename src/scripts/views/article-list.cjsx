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
		isSingle = articles.length == 1
		title = (if isSingle then articles[0].title + ' - ' else '') + @props.title
		unless isSingle
			list = (<article key={ article._id }><ArticleItem data={ article }/></article> for article in articles)
		else
			list = <ArticleItem data={ articles[0] }/>
		<DocumentTitle title={ title }>
			<div>
				{ list }
			</div>
		</DocumentTitle>
