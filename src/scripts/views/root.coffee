React = require 'react'
ReactRedux = require 'react-redux'
ReactRouter = require 'react-router'

createFactory = require '../create-factory.coffee'

Elements = require '../elements.coffee'
selectors = require '../selectors/app-selectors.coffee'
routes = require './routes.coffee'

Provider = createFactory ReactRedux.Provider
{ div } = Elements

Helmet = createFactory(
  ReactRedux.connect(selectors.titleSelector)(require 'react-helmet')
)

Router = createFactory ReactRouter.Router

module.exports = (props) ->
  { store, history, serverUrl } = props
  router = Router { history }, React.cloneElement routes, { serverUrl }
  Provider(
    { store }
    div(
      Helmet title: ''
      router
    )
  )

module.exports.displayName = 'Root'
