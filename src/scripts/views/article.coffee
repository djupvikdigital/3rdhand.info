moment = require 'moment'
React = require 'react'
Router = require 'react-router'

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
			utils.localize(@props.data.lang, @props.data)
			formatters
		)
		created = moment(article.created).format('YYYY/MM/DD')
		url = '/' + created + '/' + article.slug
		if url != @getPath()
			h = Link { to: url }, article.title
		else
			h = article.title
		div(
			h1 h
			div innerHtml: article.content
		)
