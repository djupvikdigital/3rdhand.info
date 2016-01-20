ReactRouter = require 'react-router'
ReduxRouter = require 'redux-simple-router'

routes = require './src/scripts/views/routes.coffee'
URL = require './url.coffee'

module.exports = (propsHandler) ->
	(req, res) ->
		config =
			routes: routes
			location: req.originalUrl

		ReactRouter.match config, (err, redirectLocation, props) ->
			if err
				res.status(500).send err.message
			else if redirectLocation
				res.redirect(
					302
					redirectLocation.pathname + redirectLocation.search
				)
			else
				propsHandler req, res, props
