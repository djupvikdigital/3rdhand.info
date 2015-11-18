router = require('express').Router()
ReactRouter = require 'react-router'
ReactDOM = require 'react-dom/server'
DocumentTitle = require 'react-document-title'

URL = require '../src/scripts/url.coffee'
routes = require '../src/scripts/views/routes.coffee'
init = require '../src/scripts/init.coffee'
createFactory = require '../src/scripts/create-factory.coffee'
Root = createFactory require '../src/scripts/views/root.coffee'
Template = createFactory require '../views/index.coffee'

negotiateLang = (req) ->
	l = URL.supportedLocales
	URL.negotiateLang(
		URL.getLang(req.url, l) || req.acceptsLanguages.apply(req, l)
	)

router.get '*', (req, res) ->
	lang = negotiateLang req
	url = req.originalUrl
	config =
		routes: routes
		location: url

	ReactRouter.match config, (err, redirectLocation, renderProps) ->
		if err
			res.status(500).send err.message
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
					Root path: url
				)
				title = DocumentTitle.rewind()
				html = ReactDOM.renderToStaticMarkup(
					Template title: title, app: app, lang: lang
				)
				res.send doctype + html
		else
			res.sendStatus 404

module.exports = router