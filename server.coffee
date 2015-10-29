express = require 'express'
favicon = require 'serve-favicon'
bodyParser = require 'body-parser'
Promise = require 'bluebird'
React = require 'react'
ReactDOM = require 'react-dom/server'
ReactRouter = require 'react-router'
DocumentTitle = require 'react-document-title'
t = require 'transducers.js'
docuri = require 'docuri'
createHistory = require 'history/lib/createBrowserHistory'
ReduxRouter = require 'redux-router'

Router = React.createFactory ReduxRouter.ReduxRouter
RoutingContext = React.createFactory Router.RoutingContext

global.Promise = Promise

URL = require './src/scripts/url.coffee'
db = require './db.coffee'
init = require './src/scripts/init.coffee'
store = require './src/scripts/store.coffee'
articleSelectors = require './src/scripts/selectors/article-selectors.coffee'
routes = require './src/scripts/views/routes.coffee'
Root = React.createFactory require './src/scripts/views/root.coffee'
Template = React.createFactory require './views/index.coffee'
utils = require './src/scripts/utils.coffee'

getDocumentId = docuri.route ':type/:created/:slug'

getCookie = (headers) ->
	if headers && headers['set-cookie']
		headers['set-cookie']
	else
		''

negotiateLang = (req) ->
	l = URL.supportedLocales
	URL.negotiateLang(
		URL.getLang(req.url, l) || req.acceptsLanguages.apply(req, l)
	)

main = (req, res) ->
	lang = negotiateLang req
	config =
		routes: routes
		location: req.url

	ReactRouter.match config, (err, redirectLocation, renderProps) ->
		if err
			res.send 500, err.message
		else if redirectLocation
			res.redirect(
				302
				redirectLocation.pathname + redirectLocation.search
			)
		else if renderProps
			params = renderProps.params
			if params.splat
				params = URL.getParams params.splat
			init(params, lang).then ->
				doctype = '<!DOCTYPE html>'
				app = ReactDOM.renderToString(
					Root path: req.url
				)
				title = DocumentTitle.rewind()
				html = ReactDOM.renderToStaticMarkup(
					Template title: title, app: app, lang: lang
				)
				res.send doctype + html
		else
			res.send 404, 'Not found'

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
	query = t.seq(
		utils.getProps req.query, [
			'key'
			'startkey'
			'endkey'
			'descending'
		]
		utils.mapValues utils.applyIfString JSON.parse
	)
	query.include_docs = true
	db().view 'app', req.params.view, query, (err, body) ->
		if err
			return res.send err
		docs = t.map body.rows, (row) ->
			row.doc
		res.send docs: docs

server.get '/docs', (req, res) ->
	query = utils.getProps req.query, [
		'key'
		'startkey'
		'endkey'
		'descending'
		'slug'
	]
	query.include_docs = true
	db().list query, (err, body) ->
		if err
			return res.send err
		docs = t.seq body.rows, t.compose(
			t.map (row) ->
				row.doc
		)
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
	doc._id = getDocumentId doc
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