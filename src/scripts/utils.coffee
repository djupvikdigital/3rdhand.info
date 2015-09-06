moment = require 'moment'
transducers = require 'transducers.js'
Immutable = require 'immutable'

{ compose, map, seq, toArray } = transducers

argArray = (fn) ->
	(arr) ->
		fn(arr...)

mapValue = compose map, (fn) ->
	argArray (k, v) ->
		[k, fn(v)]

shortCircuitScalars = (fn) ->
	(input) ->
		if typeof input != 'object'
			input
		else
			fn arguments...

keyIn = ->
	keySet = Immutable.Set(arguments)
	return (v, k) ->
		keySet.has k

createFunctionMapper = (functionMap, noValue) ->
	(k, v) ->
		if typeof v == 'undefined' && typeof noValue != 'undefined'
			noValue
		else if typeof functionMap[k] == 'function'
			functionMap[k](v)
		else
			v

localize = (lang, input) ->
	l = shortCircuitScalars (input) ->
		if Array.isArray input
			input.map l
		else if input.hasOwnProperty(lang)
			l(input[lang])
		else
			seq input, mapValue l
	l input

applyFormatters = shortCircuitScalars (input, formatters) ->
	if formatters
		formatMapper = createFunctionMapper(formatters, '')
	else
		formatMapper = ((k, v) -> v)
	f = shortCircuitScalars (input) ->
		if Array.isArray input
			input.map f
		else if input.hasOwnProperty('format') && input.hasOwnProperty('text')
			formatMapper(input.format, input.text)
		else
			seq input, mapValue f
	f input

addHrefToArticles = shortCircuitScalars (input) ->
	if Array.isArray input
		input.map addHrefToArticles
	else if input.hasOwnProperty('slug')
		if input.hasOwnProperty('created')
			created = input.created
		else
			created = new Date() # fake it
		created = moment(created).format('YYYY/MM/DD')
		input.href = '/' + created + '/' + input.slug
		input
	else
		seq input, mapValue addHrefToArticles

module.exports =
	addHrefToArticles: addHrefToArticles
	getFieldValueFromFormats: applyFormatters
	format: applyFormatters
	keyIn: keyIn
	localize: localize
	stripDbFields: (obj) ->
		gotMap = Immutable.Map.isMap(obj)
		m = if gotMap then obj else Immutable.Map(obj)
		m = m.filterNot keyIn '_id', '_rev'
		unless gotMap then m.toObject() else m
	validLogin: (obj) ->
		return typeof obj == "object" && 'user' of obj && 'password' of obj
