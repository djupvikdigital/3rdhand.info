React = require 'react'
Reflux = require 'reflux'
articleActions = require '../actions/article-actions.coffee'
articleStore = require '../stores/article-store.coffee'
ArticleItem = require './article.cjsx'

module.exports = React.createClass
	displayName: 'ArticleList'
	mixins: [ Reflux.listenTo(articleStore, 'onUpdate') ]
	onUpdate: (articles) ->
		@setState articles: articles
	getInitialState: ->
		articleActions.fetch()
		{ articles: [] }
	render: ->
		articles = (<ArticleItem key={ article._id } data={ article }/> for article in @state.articles)
		<div>
			{ articles }
		</div>
