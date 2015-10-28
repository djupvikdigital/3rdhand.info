React = require 'react'
DocumentTitle = React.createFactory require 'react-document-title'

createFactory = require '../create-factory.coffee'
Elements = require '../elements.coffee'

{ div, h1, header, p, b } = Elements

module.exports = React.createClass
	displayName: 'ArticleFull'
	render: ->
		if !@props.article
			return div()
		{ href, title, subtitle, intro, body } = @props.article
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
