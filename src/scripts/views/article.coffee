moment = require 'moment'
React = require 'react'
Router = require 'react-router'
DocumentTitle = React.createFactory require 'react-document-title'

formatters = require '../formatters.coffee'
utils = require '../utils.coffee'
Elements = require '../elements.coffee'

{ div, h1 } = Elements
Link = React.createFactory Router.Link

module.exports = React.createClass
	displayName: 'ArticleItem'
	mixins: [ Router.State ]
	render: ->
		article = utils.format(
			utils.localize(@props.lang, @props.article)
			formatters
		)
		created = moment(article.created).format('YYYY/MM/DD')
		url = '/' + created + '/' + article.slug
		if url != @getPath()
			h = Link { to: url }, article.title
		else
			h = article.title
		res = div(
			h1 h
			div innerHtml: article.content
		)
		if @props.title
			DocumentTitle { title: @props.title }, res
		else
			res
