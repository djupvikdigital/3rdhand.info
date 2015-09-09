React = require 'react'

Elements = require '../elements.coffee'
createFactory = require '../create-factory.coffee'

selectors = require '../selectors/article-selectors.coffee'
ArticleItem = createFactory require './article-item.coffee'

{ article, div } = Elements

module.exports = React.createClass
	displayName: 'ArticleList'
	render: ->
		lang = @props.lang
		div @props.articles.map (item) ->
			console.log item
			article { key: item._id }, ArticleItem article: item
