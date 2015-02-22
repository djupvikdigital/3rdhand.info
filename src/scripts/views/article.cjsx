React = require 'react'
Reflux = require 'reflux'

module.exports = React.createClass
	displayName: 'ArticleItem'
	render: ->
		<article>
			<h1>{ @props.data.title }</h1>
			{ @props.data.content }
		</article>

