React = require 'react'
Reflux = require 'reflux'
DocumentTitle = require 'react-document-title'

utils = require '../utils.coffee'
articleActions = require '../actions/article-actions.coffee'
articleStore = require '../stores/article-store.coffee'
ArticleItem = require './article.cjsx'
ArticleEditor = require './article-editor.cjsx'

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
		lang = articleStore.lang
		isSingle = articles.length == 1
		title = (if isSingle then utils.localize(lang, articles[0].title) + ' - ' else '') + @props.title
		unless isSingle
			datalist = ({ doc: article, lang: lang } for article in articles)
			list = (<article key={ data.doc._id }><ArticleItem data={ data }/></article> for data in datalist)
		else
			data = doc: articles[0], lang: lang
			if @props.params.view
				list = <ArticleEditor data={ data } params={ @props.params }/>
			else
				list = <ArticleItem data={ data }/>
		<DocumentTitle title={ title }>
			<div>
				{ list }
			</div>
		</DocumentTitle>
