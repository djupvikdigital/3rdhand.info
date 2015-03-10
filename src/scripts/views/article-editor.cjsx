React = require 'react'

utils = require '../utils.coffee'
articleActions = require '../actions/article-actions.coffee'

module.exports = React.createClass
	displayName: 'ArticleEditor'
	setLanguage: (lang) ->
		@setState lang: lang
	getInitialState: ->
		state = {
			lang: 'nb'
		}
		for key, val of @props.data
			state[key] = val
		state
	handleChange: (e) ->
		lang = @state.lang
		key = e.target.name
		val = e.target.value
		state = {}
		if @state[key].hasOwnProperty(lang)
			state[key] = JSON.parse JSON.stringify @state[key]
			state[key][lang] = val
		else
			state[key] = val
		@setState state
	handleSubmit: (e) ->
		e.preventDefault()
		article = {}
		for key, val of @state
			article[key] = val unless key == 'lang'
		articleActions.save article
	render: ->
		data = utils.localize @state.lang, @state
		<form onSubmit={ @handleSubmit }>
			<label><input type="radio" name="lang" value="nb" checked={ data.lang == 'nb' } onChange={ @handleChange }/> Norwegian</label>
			<label><input type="radio" name="lang" value="en" checked={ data.lang == 'en' } onChange={ @handleChange }/> English</label>
			<label>Title: <input name="title" value={ data.title } onChange={ @handleChange }/></label>
			<label>Content: <textarea name="content" value={ data.content } onChange={ @handleChange }/></label>
			<input type="submit" value="Save"/>
		</form>