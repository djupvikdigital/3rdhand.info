Immutable = require 'immutable'
React = require 'react'
Router = require 'react-router'

utils = require '../utils.coffee'
URL = require '../url.coffee'

module.exports = React.createClass
	displayName: 'Link'
	render: ->
		props = Immutable.fromJS(@props).toJS()
		{ href, params, supportedLocales } = props
		if href
			props.to = URL.getHref href, params
		React.createElement Router.Link, props