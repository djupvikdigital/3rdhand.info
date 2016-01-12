moment = require 'moment'
React = require 'react'

createFactory = require '../create-factory.coffee'
LoginDialog = createFactory require './login-dialog.coffee'
actions = require '../actions/user-actions.coffee'

checkTimestamp = (props) ->
	if props.isLoggedIn
		timestamp = props.authenticationTime
		if moment.duration(Date.now() - timestamp).asMinutes() > 30
			props.dispatch actions.sessionTimeout()

module.exports = (Component) ->
	React.createClass
		componentWillMount: ->
			checkTimestamp @props
		componentDidUpdate: ->
			checkTimestamp @props
		render: ->
			if @props.isLoggedIn
				React.createElement Component, login: @props
			else
				LoginDialog @props
