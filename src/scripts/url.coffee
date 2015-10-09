tags = require 'language-tags'
locale = require 'locale'
moment = require 'moment'
t = require 'transducers.js'

utils = require './utils.coffee'

supportedLocales = [ 'nb', 'en' ]
supportedLocalesObject = new locale.Locales supportedLocales.join ','

splitPath = (path) ->
	parts = path.split '/'
	i = parts.length - 1
	obj = {
		path: parts
	}
	filenameParts = parts[i].split '.'
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

negotiateLang = (lang) ->
	if !lang || !tags.language(lang) then return ''
	if typeof lang == 'string' && tags.language(lang).scope() == 'macrolanguage'
		lang = tags.languages(lang)
	if Array.isArray lang
		lang = lang.join ','
	negotiated = (new locale.Locales(lang)).best(supportedLocalesObject)
	if negotiated.defaulted then return ''
	negotiated.toString()

getLangFromArray = (arr) ->
	if !arr
		throw new Error('missing argument arr')
	langs = arr.filter negotiateLang
	if langs.length then langs[0] else ''

setLangInArray = (arr, lang) ->
	reducer = (v, item, i) ->
		if v == -1 && negotiateLang(item) then i else v
	if !arr
		throw new Error('missing argument arr')
	if !lang || !negotiateLang(lang)
		throw new Error('argument lang is not a supported language')
	i = arr.reduce reducer, -1
	if i != -1 then arr[i] = lang
	arr

validate = (input, validation) ->
	if validation.test input
		input
	else
		null

validationReducer = (parts, item, i, keysAndValidations) ->
	item[1] = validate parts[0], item[1]
	parts.shift() if item[1]
	if keysAndValidations.length > i + 1
		parts
	else
		keysAndValidations

module.exports =
	getHref: (path, params) ->
		obj = splitPath path
		if !getLangFromArray(obj.filename) && params.lang
			filename = obj.filename.filter Boolean
			filename[filename.length] = params.lang
			obj.filename = filename
			path = assemblePath obj
		return path
	getLang: (path) ->
		arr = splitPath(path).filename
		negotiateLang getLangFromArray arr
	setLang: (path, lang) ->
		obj = splitPath path
		setLangInArray obj.filename, lang
		assemblePath obj
	getParams: (path) ->
		obj = splitPath path
		lang = getLangFromArray obj.filename
		parts = obj.path
		i = parts.length - 1
		if parts[i] == lang
			parts[i] = ''
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
		parts = parts.filter Boolean
		params = t.toObj(
			utils.zip(keys, validation).reduce validationReducer, parts
			utils.filterValues()
		)
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
	supportedLocales: supportedLocales
