React = require 'react'

module.exports = React.createClass
	getInitialState: ->
		title: 'Lorem Ipsum'
		content: 'Lorem ipsum dolor sit amet.'
	render: ->
		<article>
			<h1>{ this.state.title }</h1>
			{ this.state.content }
		</article>

