Immutable = require 'immutable'
React = require 'react'
Router = require 'react-router'

utils = require '../utils.coffee'
URL = require '../url.coffee'

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
	React.createElement Router.Link, newProps

module.exports.displayName = 'Link'
