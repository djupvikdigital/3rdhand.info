React = require 'react'
Router = require 'react-router'
ReactRedux = require 'react-redux'

actions = require '../actions/localeActions.js'
selector = require('../selectors/appSelectors.js').linkSelector
createFactory = require '../create-factory.coffee'
Elements = require '../elements.coffee'

{ nav, ul, li, div } = Elements

Link = createFactory ReactRedux.connect(selector)(Router.Link)

propFactory = (props, langParam) ->
  onClick = ->
    props.dispatch actions.fetchStrings langParam
  return { langParam, onClick }

module.exports = (props) ->
  classes = [
    'lang-picker'
  ]
  if props.className
    classes[classes.length] = props.className
  { norwegian, english } = props.localeStrings
  nav(
    className: classes.join ' '
    ul(
      className: 'list-inline'
      li Link propFactory(props, 'no'), norwegian
      li Link propFactory(props, 'en'), english
    )
  )

module.exports.displayName = 'LangPicker'
