React = require 'react'
Immutable = require 'immutable'

Elements = require '../elements.coffee'
createFactory = require '../create-factory.coffee'

FormGroup = createFactory require './form-group.coffee'

utils = require '../utils.coffee'

{ form, label, input, textarea, div } = Elements

module.exports = React.createClass
	displayName: 'ArticleEditor'
	set: (k, v) ->
		# this will do for now
		fieldFormats =
			title: 'txt'
			content: 'md'
		lang = @state.get 'lang'
		data = @state.get 'data'
		if data.hasIn [k, lang, fieldFormats[k]]
			data = data.setIn [k, lang, fieldFormats[k]], v
		else
			data = data.set k, v
		@replaceState @state.set 'data', data
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
			props.placeholder = utils.getFieldValueFromFormats utils.localize @state.get('lang'), @props.data.doc[name]
		props
	handleChange: (e) ->
		@set e.target.name, e.target.value
	handleLanguageChange: (e) ->
		@setLanguage e.target.value
	handleSubmit: (e) ->
		e.preventDefault()
		@props.save @state.get('data').toJS()
	render: ->
		state = @state.toJS()
		data = utils.getFieldValueFromFormats utils.localize state.lang, state.data
		form(
			{ onSubmit: @handleSubmit }
			FormGroup(
				input(
					type: "radio"
					name: "lang"
					value: "nb"
					checked: (state.lang == 'nb')
					onChange: @handleLanguageChange
				)
				' Norwegian'
			)
			FormGroup(
				input(
					type: "radio"
					name: "lang"
					value: "en"
					checked: (state.lang == 'en')
					onChange: @handleLanguageChange
				)
				' English'
			)
			FormGroup(
				'Slug: '
				input(@getTextProps('slug', data))
			)
			FormGroup(
				'Title: '
				input(@getTextProps('title', data))
			)
			FormGroup(
				'Content: '
				textarea(@getTextProps('content', data))
			)
			FormGroup(
				input(className: 'btn', type: "submit", value: "Save")
			)
		)