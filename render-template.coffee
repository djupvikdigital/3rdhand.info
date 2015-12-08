ReactDOM = require 'react-dom/server'
DocumentTitle = require 'react-document-title'

init = require './src/scripts/init.coffee'
createFactory = require './src/scripts/create-factory.coffee'
Root = createFactory require './src/scripts/views/root.coffee'
IndexTemplate = createFactory require './views/index.coffee'

module.exports = (url, params, lang, Template=IndexTemplate) ->
	init(params, lang).then ->
		doctype = '<!DOCTYPE html>'
		app = ReactDOM.renderToString(
			Root path: url
		)
		title = DocumentTitle.rewind()
		html = ReactDOM.renderToStaticMarkup(
			Template title: title, app: app, lang: lang
		)
		return doctype + html
