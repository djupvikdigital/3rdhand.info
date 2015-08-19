module.exports =
	login: (login) ->
		return {
			type: 'LOGIN'
			user: login.user
			password: login.password
		}
	logout: ->
		return {
			type: 'LOGOUT'
		}