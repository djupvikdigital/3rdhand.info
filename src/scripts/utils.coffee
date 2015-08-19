Immutable = require 'immutable'
marked = require 'marked'

marked.setOptions
	sanitize: true

recursiveEmptyMapper = (v) ->
	if Immutable.Map.isMap v
		v.map recursiveEmptyMapper
	else
		''

keyIn = ->
	keySet = Immutable.Set(arguments)
	return (v, k) ->
		keySet.has k

localize = (lang, input) ->
	if typeof input != 'object'
		output = input
	else if input.hasOwnProperty(lang)
		output = localize(lang, input[lang])
	else
		output = {}
		for own key, val of input
			output[key] = localize(lang, val)
	output

getFieldValueFromFormats = (input) ->
	if typeof input != 'object'
		output = input
	else if input.hasOwnProperty('md') && input.md
		output = input.md
	else if input.hasOwnProperty('txt')
		output = input.txt
	else
		output = {}
		for own k, v of input
			output[k] = getFieldValueFromFormats(v)
	output

format = (input) ->
	if typeof input != 'object'
		output = input
	else if input.hasOwnProperty('md') && input.md
		output = marked input.md
	else if input.hasOwnProperty('txt')
		output = input.txt
	else
		output = {}
		for own k, v of input
			output[k] = format(v)
	output

module.exports =
	getFieldValueFromFormats: getFieldValueFromFormats
	format: format
	keyIn: keyIn
	localize: localize
	recursiveEmptyMapper: recursiveEmptyMapper
	stripDbFields: (obj) ->
		gotMap = Immutable.Map.isMap(obj)
		map = if gotMap then obj else Immutable.Map(obj)
		map = map.filterNot keyIn '_id', '_rev'
		unless gotMap then map.toObject() else map
	validLogin: (obj) ->
		return typeof obj == "object" && 'user' of obj && 'password' of obj
