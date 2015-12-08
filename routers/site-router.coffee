_ = require 'lodash'
t = require 'transducers.js'
moment = require 'moment'
docuri = require 'docuri'
router = require('express').Router()
ReactRouter = require 'react-router'

utils = require '../src/scripts/utils.coffee'
DB = require '../db.coffee'
routes = require '../src/scripts/views/routes.coffee'
renderTemplate = require '../render-template.coffee'
negotiateLang = require '../negotiate-lang.coffee'
URL = require '../src/scripts/url.coffee'

route = docuri.route 'article/:created'

getKey = (slug, date) ->
	dateKey = null
	if date
		if typeof date.toISOString == 'function'
			dateKey = date.toISOString()
		else
			dateKey = date
	if slug
		[ 'article', slug, dateKey ].filter Boolean
	else if dateKey
		route created: dateKey
	else
		throw new Error('could not construct key')

data = (params) ->
	query =
		endkey: [ 'article' ]
		startkey: [ 'article\uffff' ]
	view = 'by_updated'
	if params.slug
		view = 'by_slug_and_date'
		# endkey is earlier than startkey because we use descending order
		query =
			endkey: getKey params.slug
			startkey: getKey params.slug, {}
	if params.year
		dateKeys = [ 'year', 'month', 'day' ]
		dateParams = t.seq(
			utils.getProps params, dateKeys
			utils.mapValues _.parseInt
		)
		dateParams.month = dateParams.month - 1 if dateParams.month
		date = moment.utc dateParams
		durationKey = _.last t.filter(
			dateKeys
			Object.prototype.hasOwnProperty.bind dateParams
		)
		if durationKey
			query =
				endkey: getKey params.slug, date
				startkey: getKey params.slug, date.add(1, durationKey)
	query.slug = params.slug if params.slug
	query.descending = true
	DB.get view, query

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
					data params
						.then res.send.bind res
						.catch (err) ->
							res.status(500).send err
		else
			throw new Error('no route match')

module.exports = router