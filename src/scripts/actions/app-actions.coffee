assign = require 'object-assign'
ReduxRouter = require 'redux-simple-router'

URL = require '../url.coffee'

module.exports =
	init: (state) ->
		type: 'INIT'
		payload: { state }
	mergeParams: (_params) ->
		(dispatch, getState) ->
			params = assign {}, getState().routing.state, _params
			dispatch ReduxRouter.pushPath URL.getPath(params), params
