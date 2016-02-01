ReactDOM = require 'react-dom/server'
DocumentTitle = require 'react-document-title'

init = require '../src/scripts/init.coffee'
createFactory = require '../src/scripts/create-factory.coffee'
Root = createFactory require '../src/scripts/views/root.coffee'
IndexTemplate = createFactory require '../views/index.coffee'

module.exports = (storeModule, params, lang, Template=IndexTemplate) ->
  { store } = storeModule
  init(store, params, lang).then ->
    doctype = '<!DOCTYPE html>'
    app = ReactDOM.renderToString Root storeModule
    title = DocumentTitle.rewind()
    state = store.getState()
    html = ReactDOM.renderToStaticMarkup(
      Template { title, app, lang, state }
    )
    return doctype + html
