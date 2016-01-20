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

actions = require '../actions/user-actions.coffee'

{ form, label, input } = Elements

module.exports = React.createClass
	displayName: 'LoginDialog'
	getInitialData: ->
		if @props.user
			id = @props.user._id
			email = @props.user.email
		from = ''
		if @props.params
			from = JSON.stringify @props.params
		return { from, id, email }
	handleLogin: (data) ->
		@props.dispatch actions.login data
	handleLogout: (data) ->
		@props.dispatch actions.logout data
	render: ->
		{ loggedInAs, logout, email, password, login } = @props.localeStrings
		DocumentTitle(
			{ title: 'Admin' }
			Form(
				if @props.isLoggedIn
					[
						action: URL.getUserPath(@props.user._id) + '/logout'
						method: 'GET'
						initialData: @getInitialData()
						onSubmit: @handleLogout
						input type: 'hidden', name: 'from'
						input type: 'hidden', name: 'id'
						Output label: loggedInAs, name: 'email'
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
						input type: 'hidden', name: 'from'
						TextInput label: email, name: 'email'
						PasswordInput label: password, name: 'password'
						FormGroup(
							input className: 'btn', type: "submit", value: login
						)
					]
			)
		)
