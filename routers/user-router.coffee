router = require('express').Router()
session = require 'cookie-session'
moment = require 'moment'
ReactRouter = require 'react-router'

routes = require '../src/scripts/views/routes.coffee'
renderTemplate = require '../render-template.coffee'
createStore = require '../src/scripts/store.coffee'
userActions = require '../src/scripts/actions/user-actions.coffee'
articleActions = require '../src/scripts/actions/article-actions.coffee'
siteRouter = require './site-router.coffee'
URL = require '../src/scripts/url.coffee'

clearUserSession = (req) ->
	if !req
		throw new Error('missing required argument')
	if req.session
		req.session = null

router.use session(
	name: 'session'
	secret: 'topsecretstring'
	httpOnly: true
)

router.post '/', (req, res) ->
	{ store } = createStore()
	store.dispatch userActions.login req.body
		.payload.promise.then (action) ->
			{ user, timestamp } = action.payload
			req.session.user = user
			req.session.timestamp = timestamp
			res.format
				html: ->
					res.redirect 303, URL.getUserPath user._id + req.body.from
				json: ->
					res.send action.payload
		.catch (err) ->
			console.error err.stack
			res.status(err.status || 500).send err

router.use (req, res, next) ->
	timestamp = 0
	if req.session && req.session.timestamp
		timestamp = req.session.timestamp
	if !timestamp || moment.duration(Date.now() - timestamp).asMinutes() > 30
		# session timed out
		clearUserSession req
		err = new Error('session timeout')
		next err
	else
		req.session.timestamp = Date.now()
		next()

router.get '/:id/logout', (req, res) ->
	clearUserSession req
	res.format
		html: ->
			res.redirect 303, req.body.from || '/'
		default: ->
			res.status(204).send ''

router.post '/:id', (req, res) ->
	{ store } = createStore()
	store.dispatch articleActions.save req.body, req.session.user._id
		.then (body) ->
			res.send body
		.catch (err) ->
			res.status(err.status || 500).send err

router.use '/:id', siteRouter

module.exports = router