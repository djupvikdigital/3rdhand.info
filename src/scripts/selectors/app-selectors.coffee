Reselect = require 'reselect'
Immutable = require 'immutable'
{ compose } = require 'transducers.js'

utils = require '../utils.coffee'
URL = require '../url.coffee'

{ argsToObject, prop } = utils

localeSelector = compose(
  (state) ->
    lang = state.get 'lang'
    return state.getIn([ 'localeStrings', lang ]).toJS()
  prop 'localeState'
)

loginSelector = (state) ->
  params = Immutable.Map(state.routing.state).delete 'view'
  state = state.loginState.toJS()
  if state.user
    return {
      isLoggedIn: true
      user: state.user
      authenticationTime: state.authenticationTime
      params: params.delete('userId').toJS()
    }
  else
    return {
      isLoggedIn: false
      params: params.toJS()
    }

titleSelector = Reselect.createSelector [ localeSelector ], (localeStrings) ->
  return {
    title: localeStrings.title || ''
  }

paramSelector = (state) ->
  Object.assign {}, state.routing.state

headerSelector = Reselect.createSelector(
  [
    compose prop('SiteHeader'), localeSelector
    loginSelector
    paramSelector
  ]
  argsToObject 'localeStrings', 'login', 'params'
)

module.exports =
  changePasswordSelector: Reselect.createSelector(
    [ paramSelector, loginSelector, localeSelector ]
    (params, login, l) ->
      localeStrings = Object.assign(
        {}, l.ChangePasswordDialog, l.LoginDialog
      )
      return { params, login, localeStrings }
  )
  headerSelector: headerSelector
  langPickerSelector: Reselect.createSelector(
    [ paramSelector, compose(prop('LangPicker'), localeSelector) ]
    argsToObject 'params', 'localeStrings'
  )
  linkSelector: (state, props) ->
    params = Immutable.Map state.routing.location.state
      .filter utils.keyIn 'userId', 'lang'
      .set 'slug', props.slug
      .merge props.params
      .update 'lang', (v) ->
        props.langParam || v
      .toJS()
    to:
      pathname: URL.getPath params
      state: params
  localeSelector: localeSelector
  loginSelector: Reselect.createSelector(
    [ loginSelector, compose(prop('LoginDialog'), localeSelector) ]
    argsToObject 'login', 'localeStrings'
  )
  paramSelector: paramSelector
  signupSelector: Reselect.createSelector(
    [ compose(prop('SignupDialog'), localeSelector) ]
    argsToObject 'localeStrings'
  )
  titleSelector: titleSelector