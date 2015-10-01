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

assemblePath = (obj) ->
	if !Array.isArray(obj.path) || !Array.isArray(obj.filename)
		throw new Error('invalid object')
	obj.path.pop()
	if obj.path[0] then obj.path.unshift ''
	obj.filename = obj.filename.filter Boolean
	[ obj.path.join('/'), obj.filename.join('.') ].join('/')

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

setLangInArray = (arr, lang) ->
	reducer = (v, item, i) ->
		if v == -1 && tags.language(item) then i else v
	if !arr
		throw new Error('missing argument arr')
	if !lang || !tags.language(lang)
		throw new Error('argument lang is not a valid language')
	i = arr.reduceRight reducer, -1
	if i != -1 then arr[i] = lang
	arr

validate = (item) ->
	[ k, v, validation ] = item
	validation.test v

module.exports =
	getHref: (path, params) ->
		obj = splitPath path
		if !getLangFromArray(obj.filename) && params.lang
			filename = obj.filename.filter Boolean
			filename[filename.length] = params.lang
			obj.filename = filename
			path = assemblePath obj
		return path
	getLang: (path, supportedLocales) ->
		arr = splitPath(path).filename
		negotiateLang getLangFromArray(arr), supportedLocales
	setLang: (path, lang) ->
		obj = splitPath path
		setLangInArray obj.filename, lang
		assemblePath obj
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
	getPath: (params) ->
		keys = [ 'year', 'month', 'day', 'slug', 'view' ]
		path = keys.map (k) ->
			params[k]
		path = path.filter Boolean
		filename = [ path[path.length - 1] ]
		if params.lang
			filename[filename.length] = params.lang
		assemblePath path: path, filename: filename
	negotiateLang: negotiateLang
	splitPath: splitPath
