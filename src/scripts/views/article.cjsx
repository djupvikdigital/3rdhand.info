React = require 'react'
Reflux = require 'reflux'
articleActions = require '../actions/article-actions.coffee'
articleStore = require '../stores/article-store.coffee'

module.exports = React.createClass
	mixins: [ Reflux.listenTo(articleStore, 'onUpdate') ]
	onUpdate: (articles) ->
		console.log articles
		@setState articles[0]
	getInitialState: ->
		articleActions.fetch()
		{}
	render: ->
		<article>
			<h1>{ this.state.title }</h1>
			{ this.state.content }
		</article>

