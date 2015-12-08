router = require('express').Router()
docuri = require 'docuri'
session = require 'cookie-session'
moment = require 'moment'
ReactRouter = require 'react-router'

routes = require '../src/scripts/views/routes.coffee'
negotiateLang = require '../negotiate-lang.coffee'
renderTemplate = require '../render-template.coffee'
store = require '../src/scripts/store.coffee'
userActions = require '../src/scripts/actions/user-actions.coffee'
siteRouter = require './site-router.coffee'
DB = require '../db.coffee'
URL = require '../src/scripts/url.coffee'

getDocumentId = docuri.route ':type/:created/:slug'

clearUserSession = (req) ->
	if !req
		throw new Error('missing required argument')
	if req.session
		req.session = null
	store.dispatch userActions.setUser null

router.use session(
	name: 'session'
	secret: 'topsecretstring'
	httpOnly: false
)

router.post '/', (req, res) ->
	data = req.body
	DB.authenticate data.username, data.password
		.then (user) ->
			timestamp = Date.now()
			obj = _id: user._id, name: user.name
			req.session.user = obj
			req.session.timestamp = timestamp
			store.dispatch userActions.setUser obj, timestamp
			res.format
				html: ->
					res.redirect 303, URL.getUserPath user._id
				json: ->
					res.send user: obj, authenticationTime: timestamp
		.catch (err) ->
			console.error err
			res.status(err.status || 500).send err

router.use (req, res, next) ->
	timestamp = 0
	if req.session && req.session.timestamp
		timestamp = req.session.timestamp
	if !timestamp || moment.duration(Date.now() - timestamp).asSeconds() > 30
		# session timed out
		clearUserSession req
		err = new Error('session timeout')
		next err
	else
		timestamp = Date.now()
		req.session.timestamp = timestamp
		store.dispatch userActions.setUser req.session.user, timestamp
		next()

router.get '/:id/logout', (req, res) ->
	clearUserSession req
	res.format
		html: ->
			res.redirect 303, '/'
		default: ->
			res.status(204).send ''

router.post '/:id', (req, res) ->
	doc = req.body
	doc._id = getDocumentId doc
	DB.put req.session.user._id, doc
		.then (body) ->
			res.send body
		.catch (err) ->
			res.status(err.status || 500).send err

router.use '/:id', siteRouter

module.exports = router