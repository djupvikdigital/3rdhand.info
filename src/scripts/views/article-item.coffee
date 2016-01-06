React = require 'react'
Router = require 'react-router'
ReactRedux = require 'react-redux'

linkSelector = require('../selectors/app-selectors.coffee').linkSelector

createFactory = require '../create-factory.coffee'
Elements = require '../elements.coffee'

Link = createFactory ReactRedux.connect(linkSelector)(Router.Link)
{ div, header, h1, time } = Elements

module.exports = (props) ->
	{ urlParams, title, summary, published, publishedFormatted } = props.article
	div(
		header(
			h1(
				{ className: 'article__heading' }
				Link params: urlParams, innerHtml: title
			)
			time(
				{ className: 'milli', dateTime: published }
				publishedFormatted
			)
		)
		div innerHtml: summary
	)

module.exports.displayName = 'ArticleItem'
