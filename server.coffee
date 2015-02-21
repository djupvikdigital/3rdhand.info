express = require 'express'
db = require './db.coffee'

server = express()
server.use(express.static(__dirname))

server.get '/blog', (req, res) ->
	db.view('app', 'articlesByMostRecentlyUpdated', { descending: true }).pipe(res)

server.listen 8080, ->
	console.log 'Express web server listening on port 8080...'