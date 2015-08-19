React = require 'react'
ReactRedux = require 'react-redux'
Router = require 'react-router'

createFactory = require '../create-factory.coffee'
articleSelector = require '../selectors/article-selector.coffee'
loginSelector = require '../selectors/login-selector.coffee'

#ReduxDevtools = require 'redux-devtools/lib/react'

# DebugPanel = React.createFactory ReduxDevtools.DebugPanel
# DevTools = React.createFactory ReduxDevtools.DevTools
# LogMonitor = ReduxDevtools.LogMonitor

DocumentTitle = React.createFactory ReactRedux.connect(articleSelector)(require 'react-document-title')

Elements = require '../elements.coffee'
store = require '../store.coffee'
SiteMenu = createFactory ReactRedux.connect(loginSelector)(require './site-menu.coffee')

{ div } = Elements
Provider = createFactory ReactRedux.Provider
RouteHandler = React.createFactory Router.RouteHandler
Link = createFactory Router.Link

module.exports = React.createClass
	displayName: 'App'
	render: ->
		div(
			Provider(
				{ store: store }
				->
					DocumentTitle(
						{ title: '' }
						div(
							SiteMenu()
							div(
								{ className: "wrapper"}
								RouteHandler(@props)
							)
						)
					)
			)
# 			if (typeof window != 'undefined')
# 				DebugPanel(
# 					{
# 						top: true
# 						right: true
# 						bottom: true
# 						key: 'debugPanel'
# 					}
# 					DevTools({ store: store, monitor: LogMonitor })
# 				)
		)
