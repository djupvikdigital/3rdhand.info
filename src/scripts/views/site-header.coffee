React = require 'react'
ReactRedux = require 'react-redux'
Router = require 'react-router'

logo = require 'logo'

createFactory = require '../create-factory.coffee'
Elements = require '../elements.coffee'
selectors = require '../selectors/app-selectors.coffee'
userActions = require '../actions/user-actions.coffee'

{ div, header, nav, ul, li } = Elements

Link = createFactory ReactRedux.connect(selectors.linkSelector)(Router.Link)
LangPicker = createFactory ReactRedux.connect(selectors.langPickerSelector)(
  require './lang-picker.coffee'
)

module.exports = React.createClass
  displayName: 'SiteHeader'
  handleLogout: (e) ->
    e.preventDefault()
    params = Object.assign {}, @props.params
    delete params.view
    data =
      userId: @props.login.user._id
      from: JSON.stringify params
    @props.dispatch userActions.logout data
  render: ->
    { home, newArticle, changePassword, logout } = @props.localeStrings
    div(
      header(
        className: 'u-left', role: 'banner'
        Link
          className: 'site-logo'
          title: home
          innerHtml: logo
          page: 'home'
        if @props.login.isLoggedIn
          nav(
            className: 'site-menu menu'
            ul(
              className: 'list-bare'
              li Link page: 'newArticle', newArticle
              li Link page: 'changePassword', changePassword
              li Link(
                page: 'logout'
                onClick: @handleLogout
                logout
              )
            )
          )
      )
      LangPicker className: 'menu u-right'
    )
