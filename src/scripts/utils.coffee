Immutable = require 'immutable'

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
	localize: localize
	stripDbFields: (obj) ->
		map = Immutable.Map(obj).filterNot (val, key) ->
			key == '_id' || key == '_rev'
		map.toObject()