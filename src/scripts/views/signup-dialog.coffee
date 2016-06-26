React = require 'react'
ReactRedux = require 'react-redux'

createFactory = require '../create-factory.coffee'
selectors = require '../selectors/app-selectors.coffee'

Helmet = createFactory require 'react-helmet'

Elements = require '../elements.coffee'
Form = createFactory require './form.coffee'
FormMessage = createFactory ReactRedux.connect(selectors.formMessageSelector)(
  require './form-message.coffee'
)
FormGroup = createFactory require './form-group.coffee'
TextInput = createFactory require './text-input.coffee'
PasswordInput = createFactory require './password-input.coffee'

actions = require '../actions/userActions.js'

{ h1, input } = Elements

module.exports = React.createClass
  displayName: 'SignupDialog'
  handleSignup: (data) ->
    @props.dispatch actions.signup data
  render: ->
    {
      title
      email
      password
      repeatPassword
      signup
    } = @props.localeStrings
    Helmet { title }
    Form(
      onSubmit: @handleSignup
      h1 title
      FormMessage type: 'error', name: 'error'
      TextInput label: email, name: 'email'
      PasswordInput label: password, name: 'password'
      PasswordInput label: repeatPassword, name: 'repeatPassword'
      FormGroup(
        input className: 'btn', type: 'submit', value: signup
      )
    )
