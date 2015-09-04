Immutable = require 'immutable'

module.exports = (state) ->
	initialState =
		articleState: Immutable.fromJS
			title:
				nb:
					'Test'
			articles: []
			lang: 'nb'
		localeState: Immutable.fromJS
			localeStrings:
				SiteMenu: {}
				ArticleEditor: {}
				LoginDialog: {}
		loginState: Immutable.fromJS
			isLoggedIn: false
	if state
		initialState.articleState = initialState.articleState.merge(state)
	initialState