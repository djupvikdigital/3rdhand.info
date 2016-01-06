express = require 'express'
favicon = require 'serve-favicon'
bodyParser = require 'body-parser'
ReactRouter = require 'react-router'

API = require './src/scripts/node_modules/api.coffee'
{ store } = require './src/scripts/store.coffee'
articleSelectors = require './src/scripts/selectors/article-selectors.coffee'
userRouter = require './routers/user-router.coffee'
siteRouter = require './routers/site-router.coffee'
negotiateLang = require './negotiate-lang.coffee'
routes = require './src/scripts/views/routes.coffee'
URL = require './url.coffee'
renderTemplate = require './render-template.coffee'

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

server.get '/locales/:lang', (req, res) ->
	API.fetchLocaleStrings(req.params.lang).then res.send.bind res

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
				lang = negotiateLang req
				url = req.originalUrl
				config =
					location: url
					routes: routes
				ReactRouter.match config, (err, redirectLocation, props) ->
					if err
						res.status(500).send err.message
					else if redirectLocation
						res.redirect(
							302
							redirectLocation.pathname + redirectLocation.search
						)
					else if props
						params = URL.getParams props.params
						renderTemplate(url, params, lang).then res.send.bind res
			default: ->
				res.send { error: 'Not Found' }
	else if err.message == 'no route match'
		res.sendStatus 404
	else
		console.error err.stack
		res.sendStatus 500

server.listen 8081, ->
	console.log 'Express web server listening on port 8081...'