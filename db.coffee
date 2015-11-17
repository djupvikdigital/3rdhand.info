PouchDB = require 'pouchdb'
PouchDB.plugin require 'pouchdb-upsert'
Promise = require 'bluebird'
bcrypt = require 'bcrypt'
cuid = require 'cuid'

genSalt = Promise.promisify bcrypt.genSalt, bcrypt
hash = Promise.promisify bcrypt.hash, bcrypt
compare = Promise.promisify bcrypt.compare, bcrypt

t = require 'transducers.js'

utils = require './src/scripts/utils.coffee'
ddoc = require './ddoc.coffee'

diff = ->
	ddoc

db = new PouchDB('./db/thirdhandinfo')

getQueryProps = (query) ->
	props = [ 'key', 'startkey', 'endkey', 'descending' ]
	utils.getProps query, props

unserializeQueryProps = (query) ->
	t.seq(
		getQueryProps query
		utils.mapValues utils.applyIfString JSON.parse
	)

getDocFromRow = (row) ->
	row.doc

defaultTransform = (body) ->
	return docs: t.map body.rows, getDocFromRow

viewHandlers =
	by_name: (query) ->
		query.include_docs = true
		db.query 'app/by_name', query
			.then (body) ->
				if body.rows.length
					getDocFromRow body.rows[0]
				else
					error = new Error('no username match')
					error.status = 404
					throw error
	by_updated: (query) ->
		query.include_docs = true
		query.reduce = false
		db.query 'app/by_updated', query
			.then (body) ->
				return docs: t.seq body.rows, t.compose(
					t.filter (row) ->
						!row.value
					t.map getDocFromRow
				)

defaultViewHandler = (view, query) ->
	query.include_docs = true
	db.query 'app/' + view, query
		.then defaultTransform

allHandler = (query) ->
	query.include_docs = true
	db.allDocs query
		.then defaultTransform

get = (arg1) ->
	view = if arguments.length == 2 then arg1 else ''
	if view
		query = unserializeQueryProps arguments[arguments.length - 1]
	else
		query = getQueryProps arguments[arguments.length - 1]
	if !view
		allHandler query
	else if typeof viewHandlers[view] == 'function'
		viewHandlers[view](query)
	else
		defaultViewHandler view, query

put = (userId, doc) ->
	if !userId
		throw new Error('login required')
	db.get(userId).then (user) ->
		if user.roles.indexOf('write') != -1
			db.put doc
		else
			error = new Error('permission denied')
			error.status == 403
			throw error

authenticate = (username, password) ->
	viewHandlers.by_name key: [ 'user', username ]
		.then (user) ->
			compare(password, user.password_hash).then (passwordMatch) ->
				if passwordMatch then return user
				throw new Error('authentication failed')
		.catch (err) ->
			if err.status == 404
				console.log 'Invalid login attempt'
				error = new Error('authentication failed')
				error.status == 401
				throw error
			console.log err

getUserId = ->
	'user/' + cuid()

addUser = (data) ->
	if !data || data.password != data.repeatPassword
		return false
	genSalt 10
		.then (salt) ->
			hash data.password, salt
		.then (hash) ->
			doc =
				_id: getUserId()
				type: 'user'
				name: data.user
				password_hash: hash
				roles: [ 'write' ]
			db.put doc

if !true
	db.upsert ddoc._id, diff
		.then (res) ->
			if res.updated
				console.log 'Design document inserted:'
				console.log res
		.catch (err) ->
			console.log 'Error inserting design document:'
			console.log err

if !true
	db.destroy()

module.exports = {
	addUser
	authenticate
	db
	get
	put
}