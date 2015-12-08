Immutable = require 'immutable'

initialState = Immutable.fromJS({
	lang: 'nb'
	localeStrings: {
		SiteMenu: {}
		ArticleEditor: {}
		LangPicker: {}
		LoginDialog: {}
	}
})

module.exports = (state = initialState, action) ->
	switch action.type
		when 'FETCH_LOCALE_STRINGS_FULFILLED'
			return state.merge({
				lang: action.payload.lang
				localeStrings: action.payload.data
				lastUpdate: new Date()
			})
		else
			return state