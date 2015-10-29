PouchDB = require 'pouchdb'
PouchDB.plugin require 'pouchdb-upsert'

ddoc = require './ddoc.coffee'

db = new PouchDB('thirdhandinfo')
db.putIfNotExists ddoc
	.then (res) ->
		if res.updated
			console.log 'Design document inserted:'
			console.log res
	.catch (err) ->
		console.log 'Error inserting design document:'
		console.log err

module.exports = db
