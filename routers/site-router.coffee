router = require('express').Router()
ReactRouter = require 'react-router'
ReduxRouter = require 'redux-simple-router'

API = require '../src/scripts/node_modules/api.coffee'
routes = require '../src/scripts/views/routes.coffee'
renderTemplate = require '../render-template.coffee'
negotiateLang = require '../negotiate-lang.coffee'
URL = require '../url.coffee'
createStore = require '../src/scripts/store.coffee'
userActions = require '../src/scripts/actions/user-actions.coffee'

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
					storeModule = createStore()
					{ store, history } = storeModule
					id = 'user/' + params.userId
					if req.session && req.session.user._id == id
						store.dispatch userActions.setUser req.session.user._id
					store.dispatch ReduxRouter.replacePath url, params
					renderTemplate storeModule, params, lang
						.then res.send.bind res
				default: ->
					API.fetchArticles params
						.then res.send.bind res
						.catch (err) ->
							console.error err.stack
							res.status(500).send err
		else
			throw new Error('no route match')

module.exports = router
