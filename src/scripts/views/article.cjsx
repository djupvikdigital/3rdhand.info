React = require 'react'
Reflux = require 'reflux'
Router = require 'react-router'

Link = Router.Link

module.exports = React.createClass
	displayName: 'ArticleItem'
	render: ->
		<article>
			<h1><Link to={ @props.data.url }>{ @props.data.title }</Link></h1>
			{ @props.data.content }
		</article>
