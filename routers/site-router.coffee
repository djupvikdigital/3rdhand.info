router = require('express').Router()
ReactRouter = require 'react-router'

API = require '../src/scripts/node_modules/api.coffee'
routes = require '../src/scripts/views/routes.coffee'
renderTemplate = require '../render-template.coffee'
negotiateLang = require '../negotiate-lang.coffee'
URL = require '../src/scripts/url.coffee'

router.get '*', (req, res) ->
	lang = negotiateLang req
	url = req.originalUrl
	config =
		routes: routes
		location: url

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
			res.format
				html: ->
					renderTemplate(url, params, lang).then res.send.bind res
				default: ->
					API.fetchArticles params
						.then res.send.bind res
						.catch (err) ->
							res.status(500).send err
		else
			throw new Error('no route match')

module.exports = router