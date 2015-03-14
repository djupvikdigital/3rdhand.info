moment = require 'moment'
React = require 'react'
Reflux = require 'reflux'
Router = require 'react-router'

utils = require '../utils.coffee'

Link = Router.Link

module.exports = React.createClass
	displayName: 'ArticleItem'
	mixins: [ Router.State ]
	render: ->
		article = utils.localize @props.data.lang, @props.data.doc
		created = moment(article.created).format('YYYY/MM/DD')
		url = '/' + created + '/' + article.slug
		if url != @getPath()
			h1 = <Link to={ url }>{ article.title }</Link>
		else
			h1 = article.title
		<div>
			<h1>{ h1 }</h1>
			{ article.content }
		</div>
