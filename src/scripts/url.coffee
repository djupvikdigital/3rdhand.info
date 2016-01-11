utils = require './utils.coffee'

assemblePath = (obj) ->
	if !Array.isArray(obj.path) || !Array.isArray(obj.filename)
		throw new Error('invalid object')
	obj.path.pop()
	if obj.path[0] then obj.path.unshift ''
	obj.filename = obj.filename.filter Boolean
	[ obj.path.join('/'), obj.filename.join('.') ].join('/')

getUserPath = (userId) ->
	if userId
		'/users/' + utils.getUserId userId
	else
		''

setUserInArray = (arr, userId) ->
	i = arr.indexOf 'users'
	if i != -1
		arr.splice i, 0, userId
	else
		if !arr[0] then arr.unshift ''
		arr = [ 'users', userId ].concat arr
	return arr

addLangToArray = (arr, lang) ->
	if lang
		arr[arr.length] = lang

encodeMaybe = utils.maybe encodeURIComponent

getPath = (params) ->
	keys = [ 'year', 'month', 'day', 'slug', 'view' ]
	path = keys.map (k) ->
		encodeMaybe params[k]
	path = path.filter Boolean
	if params.userId
		path = setUserInArray path, params.userId
	filename = [ path[path.length - 1] ]
	addLangToArray filename, params.lang
	assemblePath path: path, filename: filename

module.exports = { getPath, getUserPath }
