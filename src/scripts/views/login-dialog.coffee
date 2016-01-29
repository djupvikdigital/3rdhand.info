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
		user = null
		params = null
		if @props.login
			{ user, params } = @props.login
		if user
			id = user._id
			name = user.name || id
		from = ''
		if params
			from = JSON.stringify params
		return { from, id, name }
	handleSubmit: (data) ->
		if data.resetPassword
			@props.dispatch actions.requestPasswordReset data
		else
			@props.dispatch actions.login data
	handleLogout: (data) ->
		@props.dispatch actions.logout data
	render: ->
		{
			loggedInAs,
			logout,
			email,
			password,
			login,
			forgotPassword
		} = @props.localeStrings
		isLoggedIn = @props.login.isLoggedIn
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
						onSubmit: @handleSubmit
						h1 title
						input type: 'hidden', name: 'from'
						TextInput label: email, name: 'email'
						PasswordInput label: password, name: 'password'
						FormGroup(
							SubmitButton login
						)
					]
			)
		)
