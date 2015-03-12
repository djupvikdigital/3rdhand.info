React = require 'react'
Immutable = require 'immutable'

utils = require '../utils.coffee'
articleActions = require '../actions/article-actions.coffee'

module.exports = React.createClass
	displayName: 'ArticleEditor'
	setLanguage: (lang) ->
		@replaceState lang: lang
	getInitialState: ->
		state = Immutable.Map lang: 'nb'
		state = state.merge @props.data
		state
	handleChange: (e) ->
		lang = @state.get 'lang'
		k = e.target.name
		v = e.target.value
		if @state.hasIn [k, lang]
			state = @state.setIn [k, lang], v
		else
			state = @state.set k, v
		@replaceState state
	handleSubmit: (e) ->
		e.preventDefault()
		article = @state.filterNot utils.keyIn 'lang'
		articleActions.save article.toJS()
	render: ->
		state = @state.toJS()
		data = utils.localize state.lang, state
		<form onSubmit={ @handleSubmit }>
			<label><input type="radio" name="lang" value="nb" checked={ data.lang == 'nb' } onChange={ @handleChange }/> Norwegian</label>
			<label><input type="radio" name="lang" value="en" checked={ data.lang == 'en' } onChange={ @handleChange }/> English</label>
			<label>Title: <input name="title" value={ data.title } onChange={ @handleChange }/></label>
			<label>Content: <textarea name="content" value={ data.content } onChange={ @handleChange }/></label>
			<input type="submit" value="Save"/>
		</form>