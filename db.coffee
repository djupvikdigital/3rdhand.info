PouchDB = require 'pouchdb'
PouchDB.plugin require 'pouchdb-upsert'

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
	db
	get
}