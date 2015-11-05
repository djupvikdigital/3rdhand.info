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
DB = require './db.coffee'
init = require './src/scripts/init.coffee'
store = require './src/scripts/store.coffee'
articleSelectors = require './src/scripts/selectors/article-selectors.coffee'
routes = require './src/scripts/views/routes.coffee'
Root = React.createFactory require './src/scripts/views/root.coffee'
Template = React.createFactory require './views/index.coffee'
utils = require './src/scripts/utils.coffee'

{ db } = DB

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

data = (req, res) ->
	DB.get(req.params.view, req.query).then (docs) ->
		res.send docs
	.catch (err) ->
		res.send 500, err


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

server.get '/views/:view', data

server.get '/docs', data

server.get 'locales/*', (req, res) ->
	console.log req.url
	res.send ''

server.get '*', main

server.post '/', (req, res) ->
	doc = req.body.doc
	doc._id = getDocumentId doc
	db.put doc
		.then (body) ->
			res.send body
		.catch (err) ->
			console.log err
			res.status(err.statusCode).send JSON.stringify err

server.listen 8081, ->
	console.log 'Express web server listening on port 8081...'