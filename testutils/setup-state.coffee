Immutable = require 'immutable'
YAML = require 'js-yaml'

utils = require '../utils.coffee'

localeStrings = YAML.safeLoad utils.read '/locales/nb.yaml'

module.exports = (state) ->
	initialState =
		articleState: Immutable.fromJS
			title:
				nb:
					'Test'
			articles: []
		localeState: Immutable.fromJS
			lang: 'nb'
			localeStrings: localeStrings
		loginState: Immutable.fromJS
			isLoggedIn: false
	if state
		initialState.articleState = initialState.articleState.merge(state)
	initialState