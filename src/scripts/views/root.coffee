ReactRedux = require 'react-redux'
ReactRouter = require 'react-router'

createFactory = require '../create-factory.coffee'

Elements = require '../elements.coffee'
selectors = require '../selectors/app-selectors.coffee'
routes = require './routes.coffee'

Provider = createFactory ReactRedux.Provider
{ div } = Elements

DocumentTitle = createFactory(
  ReactRedux.connect(selectors.titleSelector)(require 'react-document-title')
)

Router = createFactory ReactRouter.Router

module.exports = (props) ->
  { store, history } = props
  router = Router { history }, routes
  div(
    Provider(
      { store }
      DocumentTitle(
        title: ''
        router
      )
    )
  )
