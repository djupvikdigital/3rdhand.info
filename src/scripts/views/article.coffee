React = require 'react'
Router = require 'react-router'
DocumentTitle = React.createFactory require 'react-document-title'

Elements = require '../elements.coffee'

{ div, h1 } = Elements
Link = React.createFactory Router.Link

module.exports = React.createClass
	displayName: 'ArticleItem'
	mixins: [ Router.State ]
	render: ->
		article = @props.article
		href = article.href
		if href != @getPath()
			h = Link { to: href }, article.title
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
