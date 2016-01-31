ReactRedux = require 'react-redux'

createFactory = require '../create-factory.coffee'
selectors = require '../selectors/app-selectors.coffee'
Elements = require '../elements.coffee'

SiteHeader = createFactory(
  ReactRedux.connect(selectors.headerSelector)(require './site-header.coffee')
)

{ div } = Elements

module.exports = (props) ->
  div(
    className: 'u-overflow-hidden'
    SiteHeader()
    div(
      className: 'wrapper'
      props.children
    )
  )

module.exports.displayName = 'App'
