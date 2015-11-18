router = require('express').Router()
docuri = require 'docuri'
session = require 'cookie-session'

store = require '../src/scripts/store.coffee'
userActions = require '../src/scripts/actions/user-actions.coffee'
siteRouter = require './site-router.coffee'
DB = require '../db.coffee'
URL = require '../src/scripts/url.coffee'

getDocumentId = docuri.route ':type/:created/:slug'

router.use session(
	name: 'session'
	secret: 'topsecretstring'
	httpOnly: false
)

router.post '/', (req, res) ->
	data = req.body
	DB.authenticate data.username, data.password
		.then (user) ->
				req.session.user = _id: user._id, name: user.name
				res.format
					html: ->
						res.redirect 303, URL.getUserPath user._id
					json: ->
						res.send user: { _id: user._id, name: user.name }
		.catch (err) ->
			console.error err
			res.status(err.status || 500).send err

router.use (req, res, next) ->
	store.dispatch userActions.setUser req.session.user
	next()

router.get '/:id/logout', (req, res) ->
	req.session = null
	store.dispatch userActions.setUser null
	res.format
		html: ->
			res.redirect 303, '/'
		default: ->
			res.status(201).send ''

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