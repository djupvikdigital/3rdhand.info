React = require 'react'
ReactRedux = require 'react-redux'

createFactory = require '../create-factory.coffee'
URL = require '../url.coffee'
Elements = require '../elements.coffee'
actions = require '../actions/user-actions.coffee'
selectors = require '../selectors/app-selectors.coffee'

DocumentTitle = createFactory require 'react-document-title'

Form = createFactory require './form.coffee'
FormMessage = createFactory ReactRedux.connect(selectors.formMessageSelector)(
  require './form-message.coffee'
)
FormGroup = createFactory require './form-group.coffee'
TextInput = createFactory require './text-input.coffee'
PasswordInput = createFactory require './password-input.coffee'
SubmitButton = createFactory require './submit-button'

{ h1, input } = Elements

module.exports = React.createClass
  displayName: 'ChangePasswordDialog'
  handleReset: (data) ->
    @props.dispatch actions.changePassword @props.params.userId, data
      .payload.promise.then (action) ->
        method = if action.error then 'reject' else 'resolve'
        Promise[method](action.payload.response.body)
  render: ->
    location = @props.location
    data = {}
    if location && location.query
      data = location.query
    id = @props.params.userId
    timestamp = data.timestamp || ''
    token = data.token || ''
    {
      title
      oldPassword
      newPassword
      repeatPassword
      changePassword
    } = @props.localeStrings
    props =
      action: URL.getUserPath id
      method: 'POST'
      initialData: { id, timestamp, token }
      onSubmit: @handleReset
    if timestamp && token
      inputs = [
        input type: 'hidden', name: 'timestamp'
        input type: 'hidden', name: 'token'
      ]
    else
      inputs = [
        PasswordInput label: oldPassword, name: 'password'
      ]
    args = [
      props
      h1 title
      FormMessage type: 'error', name: 'error'
      input type: 'hidden', name: 'id'
    ].concat inputs, [
      PasswordInput label: newPassword, name: 'newPassword'
      PasswordInput label: repeatPassword, name: 'repeatPassword'
      FormGroup SubmitButton name: 'changePassword', changePassword
    ]
    DocumentTitle(
      title: title
      Form args
    )
