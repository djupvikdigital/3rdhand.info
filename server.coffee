express = require 'express'
db = require './db.coffee'

server = express()
server.use(express.static(__dirname))

server.use (req, res, next) ->
	res.header 'Access-Control-Allow-Origin', '*'
	res.header 'Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept'
	next()

server.get '/:view', (req, res) ->
	db.view 'app', req.params.view, req.query, (err, body) ->
		if err
			return res.send err
		lang = req.acceptsLanguages 'nb', 'en'
		docs = []
		for row in body.rows
			do ->
				doc = {}
				for key, val of row.value
					doc[key] = if val.hasOwnProperty(lang) then val[lang] else val
				docs[docs.length] = doc
		res.send docs

server.listen 8081, ->
	console.log 'Express web server listening on port 8081...'