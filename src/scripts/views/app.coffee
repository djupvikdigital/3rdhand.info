React = require 'react'
ReactRedux = require 'react-redux'

createFactory = require '../create-factory.coffee'
selectors = require '../selectors/app-selectors.coffee'
Elements = require '../elements.coffee'

SiteHeader = createFactory(
  ReactRedux.connect(selectors.headerSelector)(require './site-header.coffee')
)

{ div } = Elements

module.exports = (props) ->
  { serverUrl } = props.route
  div(
    className: 'u-overflow-hidden'
    SiteHeader()
    div(
      className: 'wrapper'
      React.cloneElement props.children, { serverUrl }
    )
  )

module.exports.displayName = 'App'
