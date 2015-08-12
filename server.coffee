express = require 'express'
bodyParser = require 'body-parser'
Promise = require 'bluebird'
React = require 'react'
Router = require 'react-router'
DocumentTitle = require 'react-document-title'

global.Promise = Promise

db = require './db.coffee'
routes = require './src/scripts/views/routes.coffee'
articleActions = require './src/scripts/actions/article-actions.coffee'
articleStore = require './src/scripts/stores/article-store.coffee'

getCookie = (headers) ->
	if headers && headers['set-cookie']
		headers['set-cookie']
	else
		''

main = (req, res) ->
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
			res.render 'index', title: title, app: html, doctype: 'strict'
		).catch((err) ->
			res.send err
		)

server = express()
server.use(express.static(__dirname))
server.use(bodyParser.json())
server.set('view engine', 'jade')

server.use (req, res, next) ->
	res.header 'Access-Control-Allow-Origin', '*'
	res.header 'Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept'
	next()

server.get '/admin', main

server.get '/:view', (req, res) ->
	query = {}
	for key, val of req.query
		query[key] = val
	query.key = JSON.parse(query.key) if typeof query.key == 'string'
	db().view 'app', req.params.view, query, (err, body) ->
		if err
			return res.send err
		lang = req.acceptsLanguages 'nb', 'en'
		docs = (row.value for row in body.rows)
		res.send docs: docs, lang: lang

server.get '*', main

server.post '/', (req, res) ->
	dbauth = ''
	callback = (err, body, headers) ->
		cookie = getCookie headers
		dbauth = cookie if cookie
		if err
			console.log err
			res.send err
		else
			res.send body
	auth = req.body.auth
	doc = req.body.doc
	if req.body.auth
		db().auth auth.user, auth.password, (err, body, headers) ->
			if err
				res.send err
			else
				dbauth = getCookie(headers)
			db(dbauth).insert doc, doc._id, callback
	else
		db().insert doc, doc._id, callback

server.listen 8081, ->
	console.log 'Express web server listening on port 8081...'