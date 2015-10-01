React = require 'react'
ReactRedux = require 'react-redux'

linkSelector = require('../selectors/app-selectors.coffee').linkSelector

createFactory = require '../create-factory.coffee'
Elements = require '../elements.coffee'

Link = createFactory ReactRedux.connect(linkSelector)(require './link.coffee')
{ div, header, h1, time } = Elements

module.exports = React.createClass
	displayName: 'ArticleItem'
	render: ->
		{ href, title, summary, published, publishedFormatted } = @props.article
		div(
			header(
				h1(
					{ className: 'article__heading' }
					Link href: href, innerHtml: title
				)
				time(
					{ className: 'milli', dateTime: published }
					publishedFormatted
				)
			)
			div innerHtml: summary
		)
