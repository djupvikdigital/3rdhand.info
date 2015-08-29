Immutable = require 'immutable'
React = require 'react'

utils = require '../utils.coffee'
Elements = require '../elements.coffee'
createFactory = require '../create-factory.coffee'

DocumentTitle = createFactory require 'react-document-title'

articleActions = require '../actions/article-actions.coffee'
store = require '../store.coffee'
ArticleItem = createFactory require './article.coffee'
ArticleEditor = createFactory require './article-editor.coffee'

{ article, div } = Elements

module.exports = React.createClass
	displayName: 'ArticleList'
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
		lang = @props.lang
		isSingle = articles.size == 1
		title = @props.title
		unless isSingle
			list = articles.map((doc) ->
				data = { doc: doc.toJS(), lang: lang }
				article(
					{ key: doc._id }
					ArticleItem(data: data)
				)
			).toJS()
		else
			data = doc: articles.get(0).toJS(), lang: lang
			if @props.params?.view
				list = [
					ArticleEditor(
						data: data
						save: @save
						localeStrings: @props.localeStrings
						params: @props.params
					)
				]
			else
				list = [
					ArticleItem data: data
				]
		DocumentTitle(
			{ title: title }
			div.apply(this, list)
		)
