API = require '../api.coffee'

module.exports =
	fetchStrings: (lang) ->
		if !lang
			throw new Error('lang parameter missing')
		type: 'FETCH_LOCALE_STRINGS'
		payload:
			promise: API.fetchLocaleStrings lang
			data: { lang }
