ReduxRouter = require 'redux-simple-router'
ReactDOM = require 'react-dom/server'
DocumentTitle = require 'react-document-title'

init = require './src/scripts/init.coffee'
createFactory = require './src/scripts/create-factory.coffee'
Root = createFactory require './src/scripts/views/root.coffee'
IndexTemplate = createFactory require './views/index.coffee'
{ store } = require './src/scripts/store.coffee'

module.exports = (url, params, lang, Template=IndexTemplate) ->
	init(params, lang).then ->
		store.dispatch ReduxRouter.replacePath url, params
		doctype = '<!DOCTYPE html>'
		app = ReactDOM.renderToString Root()
		title = DocumentTitle.rewind()
		state = store.getState()
		html = ReactDOM.renderToStaticMarkup(
			Template { title, app, lang, state }
		)
		return doctype + html
