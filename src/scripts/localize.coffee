module.exports = (lang, input) ->
	output = {}
	for key, val of input
		output[key] = if val.hasOwnProperty(lang) then val[lang] else val
	output
