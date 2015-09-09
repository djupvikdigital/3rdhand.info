React = require 'react'
Router = require 'react-router'

createFactory = require '../create-factory.coffee'
Elements = require '../elements.coffee'

{ div, header, h1, time } = Elements
Link = createFactory Router.Link

module.exports = React.createClass
	displayName: 'ArticleItem'
	render: ->
		{ href, title, summary, published, publishedFormatted } = @props.article
		div(
			header(
				h1 Link to: href, innerHtml: title
				time { dateTime: published }, publishedFormatted
			)
			div innerHtml: summary
		)
