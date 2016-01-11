Immutable = require 'immutable'

utils = require '../utils.coffee'

initialState = Immutable.fromJS
	lang: 'nb'
	localeStrings:
		nb:
			SiteMenu: {}
			ArticleEditor: {}
			LangPicker: {}
			LoginDialog: {}

reducers =
	FETCH_LOCALE_STRINGS_FULFILLED: (state, payload) ->
		state
			.mergeIn [ 'localeStrings', payload.lang ], payload.data
			.merge
				lang: payload.lang
				lastUpdate: new Date()
	INIT: (state, payload) ->
		state.merge payload.state.localeState

module.exports = (state = initialState, action) ->
	if typeof reducers[action.type] == 'function'
		reducers[action.type](state, action.payload)
	else
		return state
