validLogin = require('../utils.coffee').validLogin

module.exports = (state) ->
	state = state.loginState.toJS()
	if validLogin(state)
		return {
			isLoggedIn: true
			user: state.user
		}
	else
		return {
			isLoggedIn: false
		}