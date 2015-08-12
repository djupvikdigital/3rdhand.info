React = require 'react'
Elements = require 'react-coffee-elements'
Reflux = require 'reflux'

actions = require '../actions/login-actions.coffee'
store = require '../stores/login-store.coffee'

{ form, label, input } = Elements

module.exports = React.createClass
	displayName: 'LoginDialog'
	mixins: [
		Reflux.listenTo store, 'onUpdate'
	]
	getInitialState: ->
		store.getLogin()
	handleChange: (e) ->
		state = {}
		state[e.target.name] = e.target.value
		@setState state
	handleLogin: (e) ->
		e.preventDefault()
		actions.login @state
	handleLogout: (e) ->
		e.preventDefault()
		actions.logout()
	onUpdate: (login) ->
		@replaceState login
	render: ->
		if store.isLoggedIn()
			form(
				{ onSubmit: @handleLogout }
				'Logged in as ' + @state.user
				input(type:"submit", value: "Log out")
			)
		else
			form(
				{ onSubmit: @handleLogin }
				label(
					'Username: '
					input(
						name:"user"
						value: @state.user
						onChange: @handleChange
					)
				)
				label(
					'Password: '
					input(
						type: "password"
						name: "password"
						value: @state.password
						onChange: @handleChange
					)
				)
				input(type: "submit", value: "Log in")
			)
