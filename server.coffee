require('node-cjsx').transform()

express = require 'express'
React = require 'react'
Router = require 'react-router'
DocumentTitle = require 'react-document-title'

db = require './db.coffee'
routes = require './src/scripts/views/routes.cjsx'
articleActions = require './src/scripts/actions/article-actions.coffee'
articleStore = require './src/scripts/stores/article-store.coffee'

server = express()
server.use(express.static(__dirname))
server.set('view engine', 'jade')

server.use (req, res, next) ->
	res.header 'Access-Control-Allow-Origin', '*'
	res.header 'Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept'
	next()

server.get '/:view', (req, res) ->
	qs = {}
	for key, val of req.query
		qs[key] = JSON.parse(val)
	db.view 'app', req.params.view, qs, (err, body) ->
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

server.get '*', (req, res) ->
	router = Router.create
		routes: routes
		location: req.url
		onError: (err) ->
			console.log 'Routing error.'
			console.log err
	
	router.run (Handler, state) =>
		articleActions.fetch.triggerPromise(state.params).then((articles) ->
			html = React.renderToString React.createElement Handler, params: state.params
			title = DocumentTitle.rewind()
			res.render 'index', title: title, app: html
		).catch((err) ->
			res.send err
		)

server.listen 8081, ->
	console.log 'Express web server listening on port 8081...'