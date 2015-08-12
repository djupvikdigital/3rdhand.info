React = require 'react'
Elements = require 'react-coffee-elements'
Reflux = require 'reflux'
DocumentTitle = React.createFactory require 'react-document-title'

utils = require '../utils.coffee'
articleActions = require '../actions/article-actions.coffee'
articleStore = require '../stores/article-store.coffee'
ArticleItem = React.createFactory require './article.coffee'
ArticleEditor = React.createFactory require './article-editor.coffee'

{ article, div } = Elements

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
		title = @props.title
		if isSingle
			title = utils.getFieldValueFromFormats(utils.localize(lang, articles[0].title)) + ' - ' + title
		unless isSingle
			datalist = ({ doc: article, lang: lang } for article in articles)
			list = (article({ key: data.doc._id }, ArticleItem(data: data)) for data in datalist)
		else
			data = doc: articles[0], lang: lang
			if @props.params.view
				list = ArticleEditor data: data, params: @props.params
			else
				list = ArticleItem data: data
		DocumentTitle(
			{ title: title }
			div(
				list
			)
		)
