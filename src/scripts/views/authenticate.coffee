moment = require 'moment'
React = require 'react'

createFactory = require '../create-factory.coffee'
LoginDialog = createFactory require './login-dialog.coffee'
actions = require '../actions/user-actions.coffee'

checkTimestamp = (props) ->
	login = props.login
	if login.isLoggedIn
		timestamp = login.authenticationTime
		if moment.duration(Date.now() - timestamp).asMinutes() > 30
			props.dispatch actions.sessionTimeout()

module.exports = (Component) ->
	React.createClass
		componentWillMount: ->
			checkTimestamp @props
		componentDidUpdate: ->
			checkTimestamp @props
		render: ->
			if @props.login.isLoggedIn
				React.createElement Component, @props
			else
				LoginDialog @props
