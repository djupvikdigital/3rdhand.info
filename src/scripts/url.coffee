tags = require 'language-tags'
locale = require 'locale'
moment = require 'moment'
t = require 'transducers.js'

utils = require './utils.coffee'

splitPath = (path) ->
	parts = path.split '/'
	i = parts.length - 1
	obj = {
		path: parts
	}
	filenameParts = parts[i].split '.'
	if i < 1
		obj.path = [ '' ]
	parts[i] = filenameParts[0]
	obj.filename = filenameParts
	obj

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
	if !arr
		throw new Error('missing argument arr')
	arr.reverse()
	langs = arr.filter tags.language
	if langs.length then langs[0] else ''

validate = (item) ->
	[ k, v, validation ] = item
	validation.test v

module.exports =
	getHref: (path, params) ->
		obj = splitPath path
		obj.path.pop()
		if !getLangFromArray(obj.filename) && params.lang
			filename = obj.filename.filter Boolean
			filename[filename.length] = params.lang
			path = obj.path.join('/') + '/' + filename.join('.')
		return path
	getLang: (path, supportedLocales) ->
		arr = splitPath(path).filename
		negotiateLang getLangFromArray(arr), supportedLocales
	getParams: (path) ->
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
		params = t.toObj(
			utils.zip keys, obj.path.filter(Boolean), validation
			t.compose(
				t.filter validate
				t.map (item) ->
					t.take item, 2
				utils.filterValues()
			)
		)
		lang = getLangFromArray obj.filename
		params.lang = lang if lang
		params
	negotiateLang: negotiateLang
	splitPath: splitPath
