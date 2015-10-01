Immutable = require 'immutable'
React = require 'react'
Router = require 'react-router'

utils = require '../utils.coffee'
URL = require '../url.coffee'

module.exports = React.createClass
	displayName: 'Link'
	render: ->
		props = Immutable.fromJS(@props).filterNot(
			utils.keyIn 'href'
		).toJS()
		if @props.langParam
			props.params.lang = @props.langParam
			props.hrefLang = @props.langParam
		if !props.to
			if @props.href
				href = @props.href
			else
				href = URL.getPath props.params
				props.rel = 'alternate'
			props.to = URL.getHref href, props.params
		React.createElement Router.Link, props