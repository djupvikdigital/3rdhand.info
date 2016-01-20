express = require 'express'
favicon = require 'serve-favicon'
bodyParser = require 'body-parser'

global.__DEVTOOLS__ = false

API = require './src/scripts/node_modules/api.coffee'
createStore = require './src/scripts/store.coffee'
articleSelectors = require './src/scripts/selectors/article-selectors.coffee'
userRouter = require './routers/user-router.coffee'
siteRouter = require './routers/site-router.coffee'
defaultRouterHandler = require './default-handler.coffee'
createStore = require './src/scripts/store.coffee'

server = express()
server.use favicon './favicon.ico'
server.use(express.static(__dirname))
server.use(bodyParser.json())
server.use bodyParser.urlencoded extended: true

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
	{ store } = createStore()
	init(store).then ->
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

server.get '/locales/:lang', (req, res) ->
	API.fetchLocaleStrings(req.params.lang).then res.send.bind res

server.get '/signup', (req, res) ->
	API.isSignupAllowed().then (isAllowed) ->
		if isAllowed
			res.format
				html: ->
					defaultRouterHandler req, res
				default: ->
					res.status(204).end()
		else
			res.sendStatus 404

server.post '/signup', (req, res) ->
	API.signup req.body
		.then (body) ->
			res.send body
		.catch (err) ->
			console.log err
			res.send err

server.use '/users', userRouter
server.use '/', siteRouter

server.use (err, req, res, next) ->
	if err.message == 'session timeout'
		res.status 404
		res.format
			html: ->
				defaultRouterHandler req, res
			default: ->
				res.send { error: 'Not Found' }
	else if err.message == 'invalid login'
		res.sendStatus 400
	else if err.message == 'no route match'
		res.sendStatus 404
	else
		console.error err.stack
		res.sendStatus 500

server.listen 8081, ->
	console.log 'Express web server listening on port 8081...'