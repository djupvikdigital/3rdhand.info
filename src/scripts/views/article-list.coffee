React = require 'react'

Elements = require '../elements.coffee'
createFactory = require '../create-factory.coffee'

selectors = require '../selectors/article-selectors.coffee'
ArticleItem = createFactory require './article-item.coffee'

{ article, div } = Elements

module.exports = React.createClass
	displayName: 'ArticleList'
	render: ->
		div @props.articles.map (item) ->
			article { key: item._id }, ArticleItem article: item
