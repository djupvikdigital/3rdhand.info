tags = require 'language-tags'
locale = require 'locale'
moment = require 'moment'
t = require 'transducers.js'

utils = require './utils.coffee'

splitPath = (path) ->
	# trim slashes from path, split on slashes and dots
	parts = path.replace(/(?:^\/+)|(?:\/+$)/g, '').split '/'
	i = parts.length - 1
	filenameParts = parts[i].split '.'
	parts[i] = filenameParts[0]
	return {
		path: parts
		filename: filenameParts
	}

negotiateLang = (lang, supportedLocales) ->
	if !lang then return ''
	if !supportedLocales
		throw new Error('missing argument supportedLocales')
	if typeof lang == 'string' && tags.language(lang).scope() == 'macrolanguage'
		lang = tags.languages(lang)
	if Array.isArray lang
		lang = lang.join ','
	supported = new locale.Locales supportedLocales.join ','
	(new locale.Locales(lang)).best(supported).toString()

getLangFromArray = (arr) ->
	arr.reverse()
	langs = arr.filter tags.language
	if langs.length then langs[0] else ''

validate = (item) ->
	[ k, v, validation ] = item
	validation.test v

module.exports =
	getHref: (path, params) ->
		if !getLangFromArray splitPath(path).filename && params.lang
			path = path + '.' + params.lang
		return path
	getLang: (path, supportedLocales) ->
		arr = splitPath(path).filename
		negotiateLang getLangFromArray(arr), supportedLocales
	getParams: (path, supportedLocales) ->
		obj = splitPath path
		keys = [ 'year', 'month', 'day', 'slug', 'view' ]
		twoDigits = /^\d{2}$/
		str = /^.+$/
		validation = [
			/^\d{4}$/
			twoDigits
			twoDigits
			str
			str
		]
		params = t.toObj utils.zip(keys, obj.path, validation), t.compose(
			t.filter validate
			t.map (item) ->
				t.take item, 2
			utils.filterValues()
		)
		lang = negotiateLang getLangFromArray(obj.filename), supportedLocales
		params.lang = lang if lang
		params
	negotiateLang: negotiateLang
	splitPath: splitPath
