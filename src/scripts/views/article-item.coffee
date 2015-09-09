React = require 'react'
Router = require 'react-router'

createFactory = require '../create-factory.coffee'
Elements = require '../elements.coffee'

{ div, h1 } = Elements
Link = createFactory Router.Link

module.exports = React.createClass
	displayName: 'ArticleItem'
	render: ->
		{ href, title, summary } = @props.article
		div(
			h1 Link to: href, innerHtml: title
			div innerHtml: summary
		)
