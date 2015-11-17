React = require 'react'

createFactory = require '../create-factory.coffee'

DocumentTitle = createFactory require 'react-document-title'

Elements = require '../elements.coffee'
Form = createFactory require './form.coffee'
Output = createFactory require './output.coffee'
FormGroup = createFactory require './form-group.coffee'
TextInput = createFactory require './text-input.coffee'
PasswordInput = createFactory require './password-input.coffee'

actions = require '../actions/user-actions.coffee'

{ form, label, input } = Elements

module.exports = React.createClass
	displayName: 'LoginDialog'
	handleLogin: (data) ->
		@props.dispatch actions.login data
	handleLogout: ->
		@props.dispatch actions.logout()
	render: ->
		{ loggedInAs, logout, username, password, login } = @props.localeStrings
		initialData =
			if @props.user
				username: @props.user.name
		DocumentTitle(
			{ title: 'Admin' }
			Form(
				if @props.isLoggedIn
					[
						{ initialData: initialData, onSubmit: @handleLogout }
						Output label: loggedInAs, name: 'username'
						FormGroup(
							input className: 'btn', type:"submit", value: logout
						)
					]
				else
					[
						{ onSubmit: @handleLogin }
						TextInput label: username, name: 'username'
						PasswordInput label: password, name: 'password'
						FormGroup(
							input className: 'btn', type: "submit", value: login
						)
					]
			)
		)
