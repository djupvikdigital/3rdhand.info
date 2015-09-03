transducers = require 'transducers.js'
Immutable = require 'immutable'

{ cat, compose, filter, flatten, map, seq, take, toArray, dropWhile } = transducers

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

applyFormatters = shortCircuitScalars (input, formatters) ->
	f = shortCircuitScalars (input) ->
		if input.hasOwnProperty('format') && input.hasOwnProperty('text')
			if formatters
				createFunctionMapper(formatters, '')(input.format, input.text)
			else
				input.text
		else
			seq input, mapValue f
	f input

module.exports =
	filterValueAndKey: filterValueAndKey
	getFirstValue: getFirstValue
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
