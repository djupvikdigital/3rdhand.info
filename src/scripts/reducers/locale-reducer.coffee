Immutable = require 'immutable'

utils = require '../utils.coffee'

initialState = Immutable.fromJS({
	lang: 'nb'
	localeStrings: {
		SiteMenu: {}
		ArticleEditor: {}
		LangPicker: {}
		LoginDialog: {}
	}
})

reducers =
	FETCH_LOCALE_STRINGS_FULFILLED: (state, payload) ->
		state.merge
			lang: payload.lang
			localeStrings: payload.data
			lastUpdate: new Date()
	INIT: (state, payload) ->
		state.merge payload.state.localeState

module.exports = (state = initialState, action) ->
	if typeof reducers[action.type] == 'function'
		reducers[action.type](state, action.payload)
	else
		return state
