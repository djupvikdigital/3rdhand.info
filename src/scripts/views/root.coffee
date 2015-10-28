React = require 'react'
ReactRedux = require 'react-redux'
ReduxRouter = require 'redux-router'

ReduxDevtools = require 'redux-devtools/lib/react'

DebugPanel = React.createFactory ReduxDevtools.DebugPanel
DevTools = React.createFactory ReduxDevtools.DevTools
LogMonitor = ReduxDevtools.LogMonitor

createFactory = require '../create-factory.coffee'
Elements = require '../elements.coffee'
selectors = require '../selectors/app-selectors.coffee'
store = require '../store.coffee'
routes = require './routes.coffee'

Provider = createFactory ReactRedux.Provider
{ div } = Elements

DocumentTitle = createFactory(
	ReactRedux.connect(selectors.titleSelector)(require 'react-document-title')
)

Router = createFactory ReduxRouter.ReduxRouter

module.exports = React.createClass
	displayName: 'Root'
	render: ->
		router = Router routes
		if @props.path
			ac = ReduxRouter.replaceState null, @props.path
			store.dispatch ac
		div(
			Provider(
				store: store
				DocumentTitle(
					title: ''
					router
				)
			)
			DebugPanel(
				top: true
				right: true
				bottom: true
				key: 'debugPanel'
				DevTools store: store, monitor: LogMonitor
			)
		)