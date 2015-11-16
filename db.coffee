PouchDB = require 'pouchdb'
PouchDB.plugin require 'pouchdb-upsert'
Promise = require 'bluebird'
bcrypt = require 'bcrypt'
docuri = require 'docuri'

genSalt = Promise.promisify bcrypt.genSalt, bcrypt
hash = Promise.promisify bcrypt.hash, bcrypt
compare = Promise.promisify bcrypt.compare, bcrypt

t = require 'transducers.js'

utils = require './src/scripts/utils.coffee'
ddoc = require './ddoc.coffee'

diff = ->
	ddoc

db = new PouchDB('thirdhandinfo')

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
	by_updated: (query) ->
		query.reduce = false
		db.query 'app/by_updated', query
			.then (body) ->
				return docs: t.seq body.rows, t.compose(
					t.filter (row) ->
						!row.value
					t.map getDocFromRow
				)

defaultViewHandler = (view, query) ->
	db.query 'app/' + view, query
		.then defaultTransform

allHandler = (query) ->
	db.allDocs query
		.then defaultTransform

authenticate = (username, password) ->
	db.get 'user/' + username
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

get = (arg1) ->
	view = if arguments.length == 2 then arg1 else ''
	if view
		query = unserializeQueryProps arguments[arguments.length - 1]
	else
		query = getQueryProps arguments[arguments.length - 1]
	query.include_docs = true
	if !view
		allHandler query
	else if typeof viewHandlers[view] == 'function'
		viewHandlers[view](query)
	else
		defaultViewHandler view, query

put = (data) ->
	if !data.auth
		throw new Error('login required')
	authenticate data.auth.user, data.auth.password
		.then ->
			if @roles.indexOf('write') != -1
				db.put data.doc
			else
				error = new Error('permission denied')
				error.status == 403
				throw error

getUserId = docuri.route ':type/:name'

addUser = (data) ->
	if !data || data.password != data.repeatPassword
		return false
	genSalt 10
		.then (salt) ->
			hash data.password, salt
		.then (hash) ->
			doc =
				type: 'user'
				name: data.user
				password_hash: hash
				roles: [ 'write' ]
			doc._id = getUserId doc
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