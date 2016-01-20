React = require 'react'

createFactory = require '../create-factory.coffee'
URL = require '../url.coffee'

DocumentTitle = createFactory require 'react-document-title'

Elements = require '../elements.coffee'
Form = createFactory require './form.coffee'
Output = createFactory require './output.coffee'
FormGroup = createFactory require './form-group.coffee'
TextInput = createFactory require './text-input.coffee'
PasswordInput = createFactory require './password-input.coffee'
SubmitButton = createFactory require './submit-button.coffee'

actions = require '../actions/user-actions.coffee'

{ h1, form, label, input, button } = Elements

module.exports = React.createClass
	displayName: 'LoginDialog'
	getInitialData: ->
		if @props.user
			id = @props.user._id
			name = @props.user.name || id
		from = ''
		if @props.params
			from = JSON.stringify @props.params
		return { from, id, name }
	handleLogin: (data) ->
		@props.dispatch actions.login data
	handleLogout: (data) ->
		@props.dispatch actions.logout data
	handleClick: ->
		console.log 'foo'
	render: ->
		{
			loggedInAs,
			logout,
			email,
			password,
			login,
			forgotten_password
		} = @props.localeStrings
		isLoggedIn = @props.isLoggedIn
		title = if isLoggedIn then logout else login
		DocumentTitle(
			title: title
			Form(
				if isLoggedIn
					[
						action: URL.getUserPath(@props.user._id) + '/logout'
						method: 'GET'
						initialData: @getInitialData()
						onSubmit: @handleLogout
						h1 title
						input type: 'hidden', name: 'from'
						input type: 'hidden', name: 'id'
						Output label: loggedInAs, name: 'name'
						FormGroup(
							input className: 'btn', type:"submit", value: logout
						)
					]
				else
					[
						action: '/users'
						method: 'POST'
						initialData: @getInitialData()
						onSubmit: @handleLogin
						h1 title
						input type: 'hidden', name: 'from'
						TextInput label: email, name: 'email'
						PasswordInput label: password, name: 'password'
						FormGroup(
							SubmitButton name: 'login', login
							' '
							SubmitButton name: 'resetpwd', forgotten_password
						)
					]
			)
		)
