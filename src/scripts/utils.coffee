moment = require 'moment'
transducers = require 'transducers.js'
Immutable = require 'immutable'

{ compose, filter, map, seq, toArray } = transducers

identity = (arg) ->
	arg

argArray = (fn) ->
	(arr) ->
		fn(arr...)

filterKeys = compose filter, (fn) ->
	argArray (k) ->
		fn(k)

mapValue = compose map, (fn) ->
	argArray (k, v) ->
		[k, fn(v)]

getValuesFromPairs = (pairs) ->
	map pairs, argArray (k, v) ->
		v

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

getProps = (input, props) ->
	seq input, filterKeys (k) ->
		props.indexOf(k) != -1

thisHasProperty = (prop) ->
	this.hasOwnProperty prop

mapObjectRecursively = shortCircuitScalars (input, props, mapper) ->
	if !Array.isArray props
		props = [ props ]
	f = shortCircuitScalars (input) ->
		if Array.isArray input
			input.map f
		else if props.every Object.prototype.hasOwnProperty, input
			pairs = getProps toArray(input), props
			args = getValuesFromPairs(pairs)
			mapper.apply(input, args)
		else
			seq input, mapValue f
	f input

localize = (lang, input) ->
	mapObjectRecursively input, lang, identity

applyFormatters = shortCircuitScalars (input, formatters) ->
	if formatters
		formatMapper = createFunctionMapper(formatters, '')
	else
		formatMapper = ((k, v) -> v)
	mapObjectRecursively input, [ 'format', 'text' ], formatMapper

addHrefToArticles = (input) ->
	mapObjectRecursively input, 'slug', (slug) ->
		if @hasOwnProperty('created')
			created = @created
		else
			created = new Date() # fake it
		created = moment(created).format('YYYY/MM/DD')
		@href = '/' + created + '/' + slug
		this

module.exports =
	addHrefToArticles: addHrefToArticles
	getFieldValueFromFormats: applyFormatters
	getProps: getProps
	format: applyFormatters
	keyIn: keyIn
	localize: localize
	mapObjectRecursively: mapObjectRecursively
	stripDbFields: (obj) ->
		gotMap = Immutable.Map.isMap(obj)
		m = if gotMap then obj else Immutable.Map(obj)
		m = m.filterNot keyIn '_id', '_rev'
		unless gotMap then m.toObject() else m
	validLogin: (obj) ->
		return typeof obj == "object" && 'user' of obj && 'password' of obj
