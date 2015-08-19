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
		if @props.isLoggedIn
			form(
				{ onSubmit: @handleLogout }
				'Logged in as ' + @state.user
				input(type:"submit", value: "Log out")
			)
		else
			form(
				{ onSubmit: @handleLogin }
				FormGroup(
					'Username: '
					input(
						name:"user"
						value: @state.user
						onChange: @handleChange
					)
				)
				FormGroup(
					'Password: '
					input(
						type: "password"
						name: "password"
						value: @state.password
						onChange: @handleChange
					)
				)
				FormGroup(
					input(type: "submit", value: "Log in")
				)
			)
