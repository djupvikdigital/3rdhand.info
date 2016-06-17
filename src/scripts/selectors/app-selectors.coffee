Reselect = require 'reselect'
Immutable = require 'immutable'
omit = require 'lodash/omit'
{ compose } = require 'transducers.js'

utils = require '../utils.coffee'
URL = require 'url-helpers'

{ argsToObject, prop } = utils

localeSelector = compose(
  (state) ->
    lang = state.get 'lang'
    return state.getIn([ 'localeStrings', lang ]).toJS()
  prop 'localeState'
)

loginSelector = (state) ->
  params = omit state.appState.toJS().currentParams, 'view'
  state = state.loginState.toJS()
  if state.user
    return {
      isLoggedIn: true
      user: state.user
      authenticationTime: state.authenticationTime
      params: omit params, 'userId'
    }
  else
    return {
      isLoggedIn: false
      params: params
    }

titleSelector = Reselect.createSelector [ localeSelector ], (localeStrings) ->
  return {
    title: localeStrings.title || ''
  }

paramSelector = (state) ->
  return state.appState.toJS().currentParams

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
  formMessageSelector: compose(
    argsToObject('localeStrings'), prop('FormMessage'), localeSelector
  )
  headerSelector: headerSelector
  langPickerSelector: Reselect.createSelector(
    [ compose(prop('LangPicker'), localeSelector) ]
    argsToObject 'localeStrings'
  )
  linkSelector: (state, props) ->
    state = state.appState.toJS()
    { currentParams } = state
    params: state.params[props.page]
    params = URL.getNextParams Object.assign { currentParams, params }, props
    return Object.assign
      to:
        pathname: URL.getPath params
      omit props, 'params', 'currentParams', 'slug', 'langParam'
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
