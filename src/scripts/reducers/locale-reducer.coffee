Immutable = require 'immutable'
{ UPDATE_PATH } = require 'redux-simple-router'

utils = require '../utils.coffee'

initialState = Immutable.fromJS
	lang: 'nb'
	pendingLang: ''
	langMap: {}
	localeStrings:
		nb:
			SiteMenu: {}
			ArticleEditor: {}
			LangPicker: {}
			LoginDialog: {}

reducers =
	FETCH_LOCALE_STRINGS_PENDING: (state, payload) ->
		state.set 'pendingLang', payload.lang
	FETCH_LOCALE_STRINGS_FULFILLED: (state, payload) ->
		pending = state.get 'pendingLang'
		lang = payload.lang
		if pending != lang
			state = state.setIn [ 'langMap', pending ], lang
		state
			.mergeIn [ 'localeStrings', lang ], payload.data
			.merge
				lang: lang
				pendingLang: ''
				lastUpdate: new Date()
	INIT: (state, payload) ->
		state.merge payload.state.localeState

reducers[UPDATE_PATH] = (state, payload) ->
	lang = payload.state.lang
	if !lang
		return state.set 'lang', initialState.get 'lang'
	if state.get('langMap').has lang
		lang = state.getIn [ 'langMap', lang ]
	if state.get('lang') != lang && state.get('localeStrings').has lang
		return state.set 'lang', lang
	return state

module.exports = (state = initialState, action) ->
	if typeof reducers[action.type] == 'function'
		reducers[action.type](state, action.payload)
	else
		return state
