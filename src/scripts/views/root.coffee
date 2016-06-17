ReactRedux = require 'react-redux'

createFactory = require '../create-factory.coffee'

Elements = require '../elements.coffee'
selectors = require '../selectors/app-selectors.coffee'
routes = require './routes.coffee'

Provider = createFactory ReactRedux.Provider
{ div } = Elements

Helmet = createFactory(
  ReactRedux.connect(selectors.titleSelector)(require 'react-helmet')
)

module.exports = (props) ->
  { store } = props
  Provider(
    { store }
    div(
      Helmet title: ''
      props.children
    )
  )

module.exports.displayName = 'Root'
