React = require 'react'
ReactRedux = require 'react-redux'
Router = require 'react-router'
Reselect = require 'reselect'

createFactory = require '../create-factory.coffee'
localeActions = require '../actions/locale-actions.coffee'
selectors = require '../selectors/app-selectors.coffee'
URL = require '../url.coffee'

DocumentTitle = React.createFactory(
	ReactRedux.connect(selectors.titleSelector)(require 'react-document-title')
)

Elements = require '../elements.coffee'
store = require '../store.coffee'
SiteMenu = createFactory(
	ReactRedux.connect(selectors.menuSelector)(require './site-menu.coffee')
)

{ div } = Elements
Provider = createFactory ReactRedux.Provider
RouteHandler = React.createFactory Router.RouteHandler
Link = createFactory Router.Link

module.exports = React.createClass
	displayName: 'App'
	render: ->
		params = @props.params
		if params.splat
			params = URL.getParams params.splat
		div(
			SiteMenu()
			div(
				className: 'wrapper'
				React.cloneElement @props.children, params: params
			)
		)
