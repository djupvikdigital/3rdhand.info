Immutable = require 'immutable'
React = require 'react'
Router = require 'react-router'

utils = require '../utils.coffee'
URL = require '../url.coffee'
createFactory = require '../create-factory.coffee'

Link = createFactory Router.Link

module.exports = (props) ->
	newProps = Immutable.fromJS(props).filterNot(
		utils.keyIn 'href'
	).toJS()
	if props.langParam
		newProps.params.lang = props.langParam
		newProps.hrefLang = props.langParam
	if !props.to
		if props.href
			href = props.href
		else
			href = URL.getPath props.params
			newProps.rel = 'alternate'
		newProps.to = URL.getHref href, props.params
		if props.login.isLoggedIn
			newProps.to = URL.getUserPath(props.login.user._id) + newProps.to
	Link newProps

module.exports.displayName = 'Link'
