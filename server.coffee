express = require 'express'
favicon = require 'serve-favicon'
bodyParser = require 'body-parser'

DB = require './db.coffee'
store = require './src/scripts/store.coffee'
articleSelectors = require './src/scripts/selectors/article-selectors.coffee'
userRouter = require './routers/user-router.coffee'
siteRouter = require './routers/site-router.coffee'

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

server.post '/signup', (req, res) ->
	data = req.body
	DB.addUser data
		.then (body) ->
			res.send body
		.catch (err) ->
			console.log err
			res.send err

server.use '/users', userRouter
server.use '/', siteRouter

server.listen 8081, ->
	console.log 'Express web server listening on port 8081...'