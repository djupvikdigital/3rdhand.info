React = require 'react'
Immutable = require 'immutable'

Elements = require '../elements.coffee'
createFactory = require '../create-factory.coffee'

DocumentTitle = createFactory require 'react-document-title'

Form = createFactory require './form.coffee'
FormGroup = createFactory require './form-group.coffee'
RadioGroup = createFactory require './radio-group.coffee'
RadioOption = createFactory require './radio-option.coffee'
TextInput = createFactory require './text-input.coffee'

utils = require '../utils.coffee'

{ form, label, input, textarea, div } = Elements

keyResolver = (k) ->
	v = @state.data.getIn k
	if Immutable.Map.isMap(v)
		len = k.length
		keys = k.slice 0
		lang = @state.data.get 'lang'
		keys.splice len, 0, lang, 'text'
		keys
	else
		k

module.exports = React.createClass
	displayName: 'ArticleEditor'
	handleSubmit: (data) ->
		@props.save Immutable.fromJS(data).filterNot(utils.keyIn('lang')).toJS()
	render: ->
		data = @props.article
		isNew = @props.params.view == 'new'
		props = {
			keyResolver: keyResolver
			onSubmit: @handleSubmit
		}
		if @props.params.view != 'edit'
			data = utils.stripDbFields data
		if isNew
			props.placeholders = data
			data = @props.defaults
		if !data.slug && @props.params.slug
			data.slug = @props.params.slug
		data.lang = @props.lang
		props.initialData = data
		{ norwegian, english, slug, title, content, save } = @props.localeStrings
		DocumentTitle(
			{ title: @props.title }
			Form(
				props
				RadioGroup(
					{ name: 'lang' }
					RadioOption(label: norwegian, value: 'nb')
					RadioOption(label: english, value: 'en')
				)
				TextInput label: slug, name: 'slug'
				TextInput label: title, name: 'title'
				TextInput label: content, name: 'content', multiline: true
				FormGroup(
					input(className: 'btn', type: "submit", value: save)
				)
			)
		)