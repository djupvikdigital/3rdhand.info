fs = require 'fs'
path = require 'path'
https = require 'https'
express = require 'express'
favicon = require 'serve-favicon'
bodyParser = require 'body-parser'

PROD = process.env.NODE_ENV == 'production'
DEV = !PROD

logger = require './lib/log.coffee'
negotiateLang = require './lib/negotiate-lang.coffee'
URL = require './src/scripts/url.coffee'
init = require './src/scripts/init.coffee'
API = require './src/node_modules/api.coffee'
{ getServerUrl } = require './lib/url.coffee'
createStore = require './src/scripts/store.coffee'
articleSelectors = require './src/scripts/selectors/article-selectors.coffee'
DB = require './lib/db.coffee'
userRouter = require './routers/user-router.coffee'
siteRouter = require './routers/site-router.coffee'
defaultRouterHandler = require './lib/default-handler.coffee'
createStore = require './src/scripts/store.coffee'

certsPath = path.resolve '/etc/letsencrypt/live/3rdhand.info'

server = express()
server.use favicon './favicon.ico'
server.use(bodyParser.json())
server.use bodyParser.urlencoded extended: true

if DEV
  server.use (req, res, next) ->
    res.header 'Access-Control-Allow-Origin', '*'
    res.header(
      'Access-Control-Allow-Headers'
      'Origin, X-Requested-With, Content-Type, Accept'
    )
    next()

server.use express.static path.resolve __dirname, 'dist'
server.set 'views', './views'
server.set 'view engine', 'jade'

server.get '/index.atom', (req, res) ->
  lang = negotiateLang req
  res.header 'Content-Type', 'serverlication/atom+xml; charset=utf8'
  { store } = createStore()
  init(store, {}, lang).then ->
    articles = articleSelectors.containerSelector(store.getState()).articles
    articles.forEach (article) ->
      article.href = URL.getPath article.urlParams
    updated = if articles.length then articles[0].updated else ''
    host = getServerUrl req
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
  DB.isSignupAllowed().then (isAllowed) ->
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
      res.format
        html: ->
          res.redirect 303, URL.getUserPath body.id
        default: ->
          res.send body
    .catch (err) ->
      msg = err.message
      if msg == 'permission denied'
        logger.warn msg
        res.sendStatus 404
      else if msg == 'repeat password mismatch'
        res.status(400).send message: msg

server.use '/users', userRouter
server.use '/', siteRouter

server.use (err, req, res, next) ->
  msg = err.message
  if msg == 'session timeout' || msg = 'token expired'
    logger.warn msg
    res.format
      html: ->
        res.status 404
        defaultRouterHandler req, res
      default: ->
        res.sendStatus 404
  else if msg == 'invalid login'
    logger.warn msg
    res.sendStatus 400
  else if err.message == 'no route match'
    res.sendStatus 404
  else
    logger.error err
    res.sendStatus 500

credentials =
  key: fs.readFileSync path.join certsPath, 'privkey.pem'
  cert: fs.readFileSync path.join certsPath, 'fullchain.pem'
  ca: fs.readFileSync path.join certsPath, 'chain.pem'

if PROD
  https.createServer(credentials, server).listen 8443, ->
    logger.info 'HTTPS server listening on port 8443...'

server.listen 8081, ->
  logger.info 'Express web server listening on port 8081...'
