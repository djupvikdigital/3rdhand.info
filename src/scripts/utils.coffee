moment = require 'moment'
transducers = require 'transducers.js'
Immutable = require 'immutable'

{ compose, filter, keep, map, seq, take, toArray, transduce } = transducers

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

propsAndMappersMapper = (propsAndMapper) ->
	i = propsAndMapper.length - 1
	props = take propsAndMapper, i
	mapper = propsAndMapper[i]
	if props.every Object.prototype.hasOwnProperty, this
		pairs = getProps toArray(this), props
		args = getValuesFromPairs(pairs)
		mapper.apply(this, args)
	else
		null

mapObjectRecursively = shortCircuitScalars (input, propsAndMappers...) ->
	f = shortCircuitScalars (input) ->
		if Array.isArray input
			input.map f
		else
			if !Array.isArray propsAndMappers[0]
				propsAndMappers = [ propsAndMappers ]
			results = toArray(
				propsAndMappers
				compose map(propsAndMappersMapper, input), keep()
			)
			if results.length
				results[0]
			else
				seq input, mapValue f
	f input

createFormatMapper = (formatters) ->
	if formatters
		createFunctionMapper(formatters, '')
	else
		((k, v) -> v)

localize = (lang, input) ->
	mapObjectRecursively input, lang, identity

applyFormatters = shortCircuitScalars (input, formatters) ->
	mapObjectRecursively input, 'format', 'text', createFormatMapper formatters

hrefMapper = (slug) ->
	if @hasOwnProperty('created')
		created = @created
	else
		created = new Date() # fake it
	created = moment(created).format('YYYY/MM/DD')
	@href = '/' + created + '/' + slug
	this

addHrefToArticles = (input) ->
	mapObjectRecursively input, 'slug', hrefMapper

module.exports =
	addHrefToArticles: addHrefToArticles
	getFieldValueFromFormats: applyFormatters
	getProps: getProps
	format: applyFormatters
	hrefMapper: hrefMapper
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
