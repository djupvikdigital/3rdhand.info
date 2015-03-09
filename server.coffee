require('node-cjsx').transform()

express = require 'express'
bodyParser = require 'body-parser'
React = require 'react'
Router = require 'react-router'
DocumentTitle = require 'react-document-title'

db = require './db.coffee'
localize = require './src/scripts/localize.coffee'
routes = require './src/scripts/views/routes.cjsx'
articleActions = require './src/scripts/actions/article-actions.coffee'
articleStore = require './src/scripts/stores/article-store.coffee'

server = express()
server.use(express.static(__dirname))
server.use(bodyParser.json())
server.set('view engine', 'jade')

server.use (req, res, next) ->
	res.header 'Access-Control-Allow-Origin', '*'
	res.header 'Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept'
	next()

server.get '/:view', (req, res) ->
	query = {}
	for key, val of req.query
		query[key] = val
	query.key = JSON.parse(query.key) if typeof query.key == 'string'
	db.view 'app', req.params.view, query, (err, body) ->
		if err
			return res.send err
		lang = req.acceptsLanguages 'nb', 'en'
		if query.view == 'edit'
			docs = (row.value for row in body.rows)
		else
			docs = (localize(row.value) for row in body.rows)
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

server.post '/', (req, res) ->
	db.insert req.body, req.body._id, (err, body) ->
		res.send if err then err else body

server.listen 8081, ->
	console.log 'Express web server listening on port 8081...'