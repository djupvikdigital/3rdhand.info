Immutable = require 'immutable'

initialState = Immutable.fromJS
  isLoggedIn: false

mergeUser = (state, payload) ->
  if payload.user
    state.merge
      user: payload.user
      authenticationTime: payload.timestamp
      isLoggedIn: true
  else
    return initialState

resetState = ->
  initialState

reducers =
  LOGIN_FULFILLED: mergeUser
  SET_LOGGEDIN_USER: mergeUser
  LOGIN_REJECTED: (state, payload) ->
    initialState.set 'error', payload
  LOGOUT_PENDING: resetState
  SESSION_TIMEOUT: resetState
  INIT: (state, payload) ->
    state.merge payload.state.loginState

module.exports = (state = initialState, action) ->
  if typeof reducers[action.type] == 'function'
    reducers[action.type](state, action.payload)
  else
    return state
