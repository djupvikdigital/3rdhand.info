transducers = require 'transducers.js'
Immutable = require 'immutable'
marked = require 'marked'

{ cat, compose, filter, map, seq, take, toArray, dropWhile } = transducers

marked.setOptions
	sanitize: true

isFalsy = (v) ->
	!v

get = (k, noValue) ->
	(obj) ->
		if typeof obj[k] != 'undefined'
			obj[k]
		else
			noValue

argArray = (fn) ->
	(arr) ->
		fn(arr...)

mapValue = compose map, (fn) ->
	argArray (k, v) ->
		[k, fn(v)]

applyValue = (fn) ->
	compose(fn, get(1))

dropWhileValue = compose dropWhile, applyValue
filterValue = compose filter, applyValue

filterValueAndKey = compose filter, (fn) ->
	argArray (k, v) ->
		fn(v, k)

recursiveEmptyMapper = (v) ->
	if Immutable.Map.isMap v
		v.map recursiveEmptyMapper
	else
		''

shortCircuitScalars = (fn) ->
	(input) ->
		if typeof input != 'object'
			input
		else
			fn arguments...

getFirstKeyValue = shortCircuitScalars (input, keys...) ->
	xforms = [
		dropWhileValue(isFalsy)
		take(1)
		cat
	]
	if keys.length
		xforms.unshift filterValueAndKey(keyIn(keys...))
	toArray input, compose xforms...

getValueFromPair = (kv, noValue) ->
	get(1, noValue) kv

getFirstValue = ->
	get(1) getFirstKeyValue(arguments...)

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
		if input.hasOwnProperty(lang)
			l(input[lang])
		else
			seq input, mapValue l
	l input

createFormatMapper = (formatters) ->
	if typeof formatters != 'undefined'
		argArray(createFunctionMapper(formatters, ''))
	else
		getValueFromPair

applyFormatters = shortCircuitScalars (input, formatters) ->
	f = shortCircuitScalars (input) ->
		keys = [ 'md', 'txt' ]
		a = toArray input, filterValueAndKey(keyIn(keys...))
		if a.length
			createFormatMapper(formatters)(getFirstKeyValue(a))
		else
			seq input, mapValue f
	f input

format = (input) ->
	formatters = { md: marked }
	applyFormatters(input, formatters)

module.exports =
	filterValueAndKey: filterValueAndKey
	getFirstValue: getFirstValue
	getFieldValueFromFormats: applyFormatters
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
