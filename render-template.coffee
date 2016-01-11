ReduxRouter = require 'redux-simple-router'
ReactDOM = require 'react-dom/server'
DocumentTitle = require 'react-document-title'

init = require './src/scripts/init.coffee'
createFactory = require './src/scripts/create-factory.coffee'
Root = createFactory require './src/scripts/views/root.coffee'
IndexTemplate = createFactory require './views/index.coffee'
createStore = require './src/scripts/store.coffee'
userActions = require './src/scripts/actions/user-actions.coffee'

module.exports = (url, params, lang, Template=IndexTemplate) ->
	{ store, history } = createStore()
	if params.userId
		store.dispatch userActions.setUser 'user/' + params.userId
	init(store, params, lang).then ->
		store.dispatch ReduxRouter.replacePath url, params
		doctype = '<!DOCTYPE html>'
		app = ReactDOM.renderToString Root { store, history }
		title = DocumentTitle.rewind()
		state = store.getState()
		html = ReactDOM.renderToStaticMarkup(
			Template { title, app, lang, state }
		)
		return doctype + html
