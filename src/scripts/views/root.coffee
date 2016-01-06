ReactRedux = require 'react-redux'
ReactRouter = require 'react-router'

ReduxDevtools = require 'redux-devtools/lib/react'

createFactory = require '../create-factory.coffee'

DebugPanel = createFactory ReduxDevtools.DebugPanel
DevTools = createFactory ReduxDevtools.DevTools
LogMonitor = ReduxDevtools.LogMonitor

Elements = require '../elements.coffee'
selectors = require '../selectors/app-selectors.coffee'
{ store, history } = require '../store.coffee'
routes = require './routes.coffee'

Provider = createFactory ReactRedux.Provider
{ div } = Elements

DocumentTitle = createFactory(
	ReactRedux.connect(selectors.titleSelector)(require 'react-document-title')
)

Router = createFactory ReactRouter.Router

module.exports = (props) ->
	router = Router { history }, routes
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
