Immutable = require 'immutable'

initialState = Immutable.fromJS({
	lang: 'nb'
	localeStrings: {
		SiteMenu: {}
		ArticleEditor: {}
		LoginDialog: {}
	}
})

module.exports = (state = initialState, action) ->
	switch action.type
		when 'RECEIVE_LOCALE_STRINGS_SUCCESS'
			return state.merge({
				lang: action.lang
				localeStrings: action.data
				lastUpdate: action.receivedAt
			})
		else
			return state