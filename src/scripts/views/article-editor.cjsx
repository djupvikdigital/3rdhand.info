React = require 'react'
Immutable = require 'immutable'

utils = require '../utils.coffee'
articleActions = require '../actions/article-actions.coffee'

module.exports = React.createClass
	displayName: 'ArticleEditor'
	setLanguage: (lang) ->
		@replaceState @state.set('lang', lang)
	getInitialState: ->
		data = Immutable.fromJS @props.data.doc
		if @props.params.view != 'edit'
			data = utils.stripDbFields data
		if @props.params.view == 'new'
			data = data.map utils.recursiveEmptyMapper
		if !data.get('slug') && @props.params.slug
			data = data.set 'slug', @props.params.slug
		Immutable.Map
			lang: @props.data.lang
			data: data
	getTextProps: (name, data) ->
		props =
			name: name
			value: data[name]
			onChange: @handleChange
		if @props.params.view == 'new'
			props.placeholder = utils.localize @state.get('lang'), @props.data.doc[name]
		props
	handleChange: (e) ->
		lang = @state.get 'lang'
		data = @state.get 'data'
		k = e.target.name
		v = e.target.value
		if data.hasIn [k, lang]
			data = data.setIn [k, lang], v
		else
			data = data.set k, v
		@replaceState @state.set 'data', data
	handleLanguageChange: (e) ->
		@setLanguage e.target.value
	handleSubmit: (e) ->
		e.preventDefault()
		articleActions.save @state.get('data').toJS()
	render: ->
		state = @state.toJS()
		data = utils.localize state.lang, state.data
		props =
			slug: @getTextProps('slug', data)
			title: @getTextProps('title', data)
			content: @getTextProps('content', data)
		<form onSubmit={ @handleSubmit }>
			<label><input type="radio" name="lang" value="nb" checked={ state.lang == 'nb' } onChange={ @handleLanguageChange }/> Norwegian</label>
			<label><input type="radio" name="lang" value="en" checked={ state.lang == 'en' } onChange={ @handleLanguageChange }/> English</label>
			<label>Slug: <input {...props.slug}/></label>
			<label>Title: <input {...props.title}/></label>
			<label>Content: <textarea {...props.content}/></label>
			<input type="submit" value="Save"/>
		</form>