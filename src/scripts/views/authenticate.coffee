moment = require 'moment'
React = require 'react'

createFactory = require '../create-factory.coffee'
LoginDialog = createFactory require './login-dialog.coffee'
actions = require '../actions/user-actions.coffee'

module.exports = (Component) ->
	(props) ->
		if props.isLoggedIn
			if moment.duration(Date.now() - props.timestamp).asSeconds() > 30
				props.dispatch actions.sessionTimeout()
				LoginDialog props
			else
				React.createElement Component, {}
		else
			LoginDialog props
