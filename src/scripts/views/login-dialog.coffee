Immutable = require 'immutable'
React = require 'react'
ReactRedux = require 'react-redux'

createFactory = require '../create-factory.coffee'
selectors = require '../selectors/appSelectors.js'
URL = require 'urlHelpers'

Helmet = createFactory require 'react-helmet'

Elements = require '../elements.coffee'
Form = createFactory require './form.coffee'
FormMessage = createFactory ReactRedux.connect(selectors.formMessageSelector)(
  require './form-message.coffee'
)
Output = createFactory require './output.coffee'
FormGroup = createFactory require './FormGroup.js'
TextInput = createFactory require './text-input.coffee'
PasswordInput = createFactory require './password-input.coffee'
SubmitButton = createFactory require './submit-button.coffee'

actions = require '../actions/userActions.js'

{ h1, form, label, input, button } = Elements

module.exports = React.createClass
  displayName: 'LoginDialog'
  getInitialData: ->
    user = null
    params = null
    error = ''
    if @props.login
      { user, params } = @props.login
    if user
      userId = user._id
      name = user.name || userId
    from = ''
    if params
      from = JSON.stringify params
    return { from, userId, name, error }
  handleSubmit: (data) ->
    if data.resetPassword
      promise = @props.dispatch actions.requestPasswordReset data
    else
      promise = @props.dispatch actions.login data
    promise.then ({ action, value }) ->
      method = if action.error then 'reject' else 'resolve'
      Promise[method](value)
  handleLogout: (data) ->
    @props.dispatch actions.logout data
  render: ->
    l = @props.localeStrings
    {
      loggedInAs
      logout
      email
      password
      login
      forgotPassword
    } = l
    isLoggedIn = @props.login.isLoggedIn
    title = if isLoggedIn then logout else login
    Helmet { title }
    Form(
      if isLoggedIn
        [
          action: URL.getUserPath(@props.login.user._id) + '/logout'
          method: 'GET'
          initialData: @getInitialData()
          onSubmit: @handleLogout
          h1 title
          input type: 'hidden', name: 'from'
          input type: 'hidden', name: 'userId'
          Output label: loggedInAs, name: 'name'
          FormGroup(
            input className: 'btn', type: 'submit', value: logout
          )
        ]
      else
        [
          action: '/users'
          method: 'POST'
          initialData: @getInitialData()
          onSubmit: @handleSubmit
          h1 title
          FormMessage type: 'error', name: 'error'
          input type: 'hidden', name: 'from'
          TextInput label: email, name: 'email'
          PasswordInput label: password, name: 'password'
          FormGroup(
            SubmitButton login
          )
        ]
    )
