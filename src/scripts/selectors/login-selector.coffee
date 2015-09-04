validLogin = require('../utils.coffee').validLogin

module.exports = (state) ->
	localeStrings = state.localeState.getIn([ 'localeStrings', 'LoginDialog' ]).toJS()
	state = state.loginState.toJS()
	if validLogin(state)
		return {
			isLoggedIn: true
			user: state.user
			localeStrings: localeStrings
		}
	else
		return {
			isLoggedIn: false
			localeStrings: localeStrings
		}