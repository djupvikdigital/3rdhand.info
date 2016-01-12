docuri = require 'docuri'
t = require 'transducers.js'
Immutable = require 'immutable'

{ compose, filter, keep, map, remove, seq, take, toArray, transduce } = t

getUserId = docuri.route 'user/:cuid'

isObject = (x) ->
	x instanceof Object && Object.getPrototypeOf(x) == Object.getPrototypeOf {}

array = ->
	# cast to array
	Array.prototype.concat.apply [], arguments

identity = (arg) ->
	arg

applyArgOfType = (type, fn) ->
	(input) ->
		if typeof input == type
			fn input
		else
			input

defaultFilter = (item) ->
	!!item

argArray = (fn) ->
	(arg) ->
		if Array.isArray arg
			fn arg...
		else
			fn arg

get = (prop, fn) ->
	(obj) ->
		if typeof fn == 'function'
			fn obj[prop]
		else
			obj[prop]

keyFilter = (fn) ->
	argArray (k) ->
		fn(k)

filterKeys = compose filter, keyFilter

filterValues = compose filter, (fn=defaultFilter) ->
	argArray (k, v) ->
		fn(v)

mapValues = compose map, (fn) ->
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

zip = (arrs) ->
	if arguments.length > 1
		arrs = Array.prototype.slice.call arguments
	len = arrs.length
	res = for i in [0...arrs[0].length]
		item = []
		for j in [0...len]
			item[item.length] = arrs[j][i]

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
	if !Array.isArray propsAndMappers[0]
		propsAndMappers = [ propsAndMappers ]
	f = shortCircuitScalars (input) ->
		if Array.isArray input
			input.map f
		else if isObject input
			results = toArray(
				propsAndMappers
				compose map(propsAndMappersMapper, input), keep()
			)
			if results.length
				f results[0]
			else
				seq input, mapValues f
		else
			input
	f input

createPropertyMapper = (k, fn) ->
	->
		if @hasOwnProperty k
			null
		else
			this[k] = fn.apply this, arguments
			this

createFormatMapper = (formatters) ->
	if formatters
		createFunctionMapper(formatters, '')
	else
		((k, v) -> v)

applyFormatters = shortCircuitScalars (input, formatters) ->
	mapObjectRecursively input, 'format', 'text', createFormatMapper formatters

maybe = (fn) ->
	(arg) ->
		if arg then fn(arg) else null

module.exports =
	applyFormatters: applyFormatters
	argsToObject: ->
		keys = arguments
		reducer = (obj, arg, i) ->
			obj[keys[i]] = arg
			return obj
		->
			Array.prototype.reduce.call arguments, reducer, {}
	array: array
	createFormatMapper: createFormatMapper
	createPropertyMapper: createPropertyMapper
	get: get
	getProps: getProps
	getUserId: (userId) ->
		getUserId(userId).cuid || userId
	filterValues: filterValues
	identity: identity
	keyIn: keyIn
	mapObjectRecursively: mapObjectRecursively
	mapValues: mapValues
	maybe: maybe
	stripDbFields: (obj) ->
		gotMap = Immutable.Map.isMap(obj)
		m = if gotMap then obj else Immutable.Map(obj)
		m = m.filterNot keyIn '_id', '_rev'
		unless gotMap then m.toObject() else m
	zip: zip
