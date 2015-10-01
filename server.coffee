express = require 'express'
favicon = require 'serve-favicon'
bodyParser = require 'body-parser'
Promise = require 'bluebird'
React = require 'react'
Router = require 'react-router'
DocumentTitle = require 'react-document-title'

global.Promise = Promise

URL = require './src/scripts/url.coffee'
db = require './db.coffee'
init = require './src/scripts/init.coffee'
store = require './src/scripts/store.coffee'
articleSelectors = require './src/scripts/selectors/article-selectors.coffee'
routes = require './src/scripts/views/routes.coffee'
Template = React.createFactory require './views/index.coffee'

getCookie = (headers) ->
	if headers && headers['set-cookie']
		headers['set-cookie']
	else
		''

main = (req, res) ->
	supportedLocales = store.getState().localeState.toJS().supportedLocales
	lang = URL.negotiateLang(
		(URL.getLang(req.url, supportedLocales) || req.acceptsLanguages.apply(req, supportedLocales))
		supportedLocales
	)
	router = Router.create
		routes: routes
		location: req.url
		onError: (err) ->
			console.log 'Routing error.'
			console.log err

	router.run (Handler, state) =>
		params = state.params
		if params.splat
			params = URL.getParams params.splat
		init(params, lang).then ->
			doctype = '<!DOCTYPE html>'
			app = React.renderToString(
				React.createElement Handler, params: params
			)
			title = DocumentTitle.rewind()
			html = React.renderToStaticMarkup(
				Template title: title, app: app, lang: params.lang
			)
			res.send doctype + html

server = express()
server.use favicon './favicon.ico'
server.use(express.static(__dirname))
server.use(bodyParser.json())

server.use (req, res, next) ->
	res.header 'Access-Control-Allow-Origin', '*'
	res.header 'Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept'
	next()

server.set 'views', './views'
server.set 'view engine', 'jade'

server.get '/admin', main

server.get '/index.atom', (req, res) ->
	res.header 'Content-Type', 'text/plain; charset=utf8'
	lang = req.acceptsLanguages 'nb', 'en'
	res.header 'Content-Type', 'application/atom+xml; charset=utf8'
	init().then ->
		articles = articleSelectors.containerSelector(store.getState()).articles
		updated = if articles.length then articles[0].updated else ''
		host = req.protocol + '://' + req.get('host')
		res.render(
			'feed'
			host: host
			root: host + '/'
			url: host + req.url
			updated: updated
			articles: articles
		)

server.get '/views/:view', (req, res) ->
	query = {}
	for key, val of req.query
		query[key] = val
	query.key = JSON.parse(query.key) if typeof query.key == 'string'
	db().view 'app', req.params.view, query, (err, body) ->
		if err
			return res.send err
		docs = (row.value for row in body.rows)
		res.send docs: docs

server.get 'locales/*', (req, res) ->
	console.log req.url
	res.send ''

server.get '*', main

server.post '/', (req, res) ->
	dbauth = ''
	callback = (err, body, headers) ->
		cookie = getCookie headers
		dbauth = cookie if cookie
		if err
			console.log err
			res.status(err.statusCode).send JSON.stringify err
		else
			res.send body
	auth = req.body.auth
	doc = req.body.doc
	if req.body.auth
		db().auth auth.user, auth.password, (err, body, headers) ->
			if err
				res.status(err.statusCode).send JSON.stringify err
			else
				dbauth = getCookie(headers)
			db(dbauth).insert doc, doc._id, callback
	else
		db().insert doc, doc._id, callback

server.listen 8081, ->
	console.log 'Express web server listening on port 8081...'