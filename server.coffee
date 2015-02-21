express = require 'express'
db = require './db.coffee'

server = express()
server.use(express.static(__dirname))

server.use (req, res, next) ->
	res.header 'Access-Control-Allow-Origin', '*'
	res.header 'Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept'
	next()

server.get '/blog', (req, res) ->
	db.view('app', 'articlesByMostRecentlyUpdated', { descending: true }).pipe(res)

server.listen 8081, ->
	console.log 'Express web server listening on port 8081...'