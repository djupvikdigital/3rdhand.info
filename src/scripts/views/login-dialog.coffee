React = require 'react'

createFactory = require '../create-factory.coffee'
Elements = require '../elements.coffee'
FormGroup = createFactory require './form-group.coffee'

actions = require '../actions/login-actions.coffee'

{ form, label, input } = Elements

module.exports = React.createClass
	displayName: 'LoginDialog'
	propsToState: (props) ->
		return {
			user: props.user
			password: ''
		}
	getInitialState: ->
		@propsToState(@props)
	handleChange: (e) ->
		state = {}
		state[e.target.name] = e.target.value
		@setState state
	handleLogin: (e) ->
		e.preventDefault()
		@props.dispatch actions.login @state
	handleLogout: (e) ->
		e.preventDefault()
		@props.dispatch actions.logout()
	componentWillReceiveProps: (nextProps) ->
		@replaceState @propsToState nextProps
	render: ->
		{ loggedInAs, logoutLabel, usernameLabel, passwordLabel, loginLabel } = @props.localeStrings
		if @props.isLoggedIn
			form(
				{ onSubmit: @handleLogout }
				loggedInAs + ' ' + @state.user
				FormGroup(
					input(className: 'btn', type:"submit", value: logoutLabel)
				)
			)
		else
			form(
				{ onSubmit: @handleLogin }
				FormGroup(
					usernameLabel + ': '
					input(
						name:"user"
						value: @state.user
						onChange: @handleChange
					)
				)
				FormGroup(
					passwordLabel + ': '
					input(
						type: "password"
						name: "password"
						value: @state.password
						onChange: @handleChange
					)
				)
				FormGroup(
					input(className: 'btn', type: "submit", value: loginLabel)
				)
			)
