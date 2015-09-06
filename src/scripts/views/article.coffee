React = require 'react'
Router = require 'react-router'
DocumentTitle = React.createFactory require 'react-document-title'

createFactory = require '../create-factory.coffee'
Elements = require '../elements.coffee'

{ div, h1 } = Elements
Link = createFactory Router.Link

module.exports = React.createClass
	displayName: 'ArticleItem'
	mixins: [ Router.State ]
	render: ->
		article = @props.article
		href = article.href
		if href != @getPath()
			h = h1 Link to: href, innerHtml: article.title
		else
			h = h1 innerHtml: article.title
		res = div(
			h
			div innerHtml: article.content
		)
		if @props.title
			DocumentTitle { title: @props.title }, res
		else
			res
