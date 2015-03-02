React = require 'react'
Reflux = require 'reflux'
Router = require 'react-router'

Link = Router.Link

module.exports = React.createClass
	displayName: 'ArticleItem'
	mixins: [ Router.State ]
	render: ->
		if @props.data.url != @getPath()
			h1 = <Link to={ @props.data.url }>{ @props.data.title }</Link>
		else
			h1 = @props.data.title
		<div>
			<h1>{ h1 }</h1>
			{ @props.data.content }
		</div>
