request = require 'superagent'
require('superagent-as-promised')(request)
YAML = require 'js-yaml'
{ compose } = require 'transducers.js'

protocol = 'http://'
host = 'localhost:8081'
server = protocol + host + '/'

requestLocaleStrings = (lang) ->
	return {
		type: 'REQUEST_LOCALE_STRINGS'
		lang: lang
	}

receiveLocaleStrings = (lang) ->
	(res) ->
		if res.ok
			return {
				type: 'RECEIVE_LOCALE_STRINGS_SUCCESS'
				lang: lang
				data: YAML.safeLoad(res.text)
				receivedAt: new Date()
			}
		else
			return {
				type: 'RECEIVE_LOCALE_STRINGS_ERROR'
				lang: lang
				error: res
			}

module.exports =
	fetchStrings: (lang) ->
		(dispatch) ->
			if !lang
				return dispatch {
					type: 'REQUEST_LOCALE_STRINGS_ERROR'
					error: 'lang parameter missing'
				}
			dispatch requestLocaleStrings(lang)
			req = request(server + 'locales/' + lang + '.yaml')
			handler = compose dispatch, receiveLocaleStrings lang
			if typeof req.buffer == 'function'
				req.buffer()
			req
				.then(handler)
				.catch(handler)
