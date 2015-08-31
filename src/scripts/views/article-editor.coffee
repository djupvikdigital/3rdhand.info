React = require 'react'
Immutable = require 'immutable'

Elements = require '../elements.coffee'
createFactory = require '../create-factory.coffee'

Form = createFactory require './form.coffee'
FormGroup = createFactory require './form-group.coffee'
RadioGroup = createFactory require './radio-group.coffee'
RadioOption = createFactory require './radio-option.coffee'
TextInput = createFactory require './text-input.coffee'

utils = require '../utils.coffee'

{ form, label, input, textarea, div } = Elements

keyResolver = (k) ->
	# this will do for now
	fieldFormats =
		title: 'txt'
		content: 'md'
	v = @state.data.getIn k
	if Immutable.Map.isMap(v)
		len = k.length
		keys = k.slice 0
		lang = @state.data.get 'lang'
		keys.splice len, 0, lang, fieldFormats[k[len - 1]]
		keys
	else
		k

module.exports = React.createClass
	displayName: 'ArticleEditor'
	handleSubmit: (data) ->
		@props.save Immutable.fromJS(data).filterNot(utils.keyIn('lang')).toJS()
	render: ->
		data = Immutable.fromJS(@props.data).filterNot(utils.keyIn('lang'))
		isNew = @props.params.view == 'new'
		props = {
			keyResolver: keyResolver
			onSubmit: @handleSubmit
		}
		if @props.params.view != 'edit'
			data = utils.stripDbFields data
		if isNew
			props.placeholders = data.toJS()
			data = data.map utils.recursiveEmptyMapper
		if !data.has('slug') && @props.params.slug
			data = data.set 'slug', @props.params.slug
		props.initialData = data.toJS()
		props.initialData.lang = @props.data.lang
		{ norwegian, english, slugLabel, titleLabel, contentLabel, save } = @props.localeStrings
		Form(
			props
			RadioGroup(
				{ name: 'lang' }
				RadioOption(label: norwegian, value: 'nb')
				RadioOption(label: english, value: 'en')
			)
			TextInput label: slugLabel, name: 'slug'
			TextInput label: titleLabel, name: 'title'
			TextInput label: contentLabel, name: 'content', multiline: true
			FormGroup(
				input(className: 'btn', type: "submit", value: save)
			)
		)