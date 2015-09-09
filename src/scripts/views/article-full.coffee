React = require 'react'
Router = require 'react-router'
DocumentTitle = React.createFactory require 'react-document-title'

createFactory = require '../create-factory.coffee'
Elements = require '../elements.coffee'

{ div, h1, header, p, b } = Elements
Link = createFactory Router.Link

module.exports = React.createClass
	displayName: 'ArticleFull'
	mixins: [ Router.State ]
	render: ->
		{ href, title, subtitle, intro, body } = @props.article
		if href != @getPath()
			h = h1 Link to: href, innerHtml: title
		else
			h = h1 innerHtml: title
		if subtitle
			h = header h, p innerHtml: subtitle
		res = div(
			h
			if intro
				p b className: 'intro', innerHtml: intro
			div innerHtml: body
		)
		if @props.title
			DocumentTitle { title: @props.title }, res
		else
			res
