Immutable = require 'immutable'

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

module.exports =
	keyIn: keyIn
	localize: localize
	stripDbFields: (obj) ->
		gotMap = Immutable.Map.isMap(obj)
		map = if gotMap then obj else Immutable.Map(obj)
		map = map.filterNot keyIn '_id', '_rev'
		unless gotMap then map.toObject() else map
