ReduxRouter = require 'react-router-redux'

API = require 'api'
utils = require '../utils.coffee'
URL = require 'urlHelpers'
appActions = require './app-actions.coffee'

module.exports =
  sessionTimeout: ->
    type: 'SESSION_TIMEOUT'
  login: (data) ->
    (dispatch) ->
      dispatch(
        type: 'LOGIN'
        payload:
          promise: API.login(data)
      ).then (res) ->
        { value } = res
        params = if data.from then JSON.parse(data.from) else {}
        params.userId = utils.getUserId value.user._id
        dispatch ReduxRouter.push(
          pathname: URL.getPath(params), state: params
        )
        return res
  logout: (data) ->
    (dispatch) ->
      dispatch(
        type: 'LOGOUT'
        payload:
          promise: API.logout(data.userId)
      ).then (res) ->
        params = if data.from then JSON.parse data.from else {}
        delete params.userId
        dispatch ReduxRouter.push(
          pathname: URL.getPath(params), state: params
        )
        return res
  changePassword: (userId, data) ->
    type: 'CHANGE_PASSWORD'
    payload:
      promise: API.changePassword userId, data
  requestPasswordReset: (data) ->
    type: 'REQUEST_PASSWORD_RESET'
    payload:
      promise: API.requestPasswordReset data
  setUser: (obj, timestamp) ->
    type: 'SET_LOGGEDIN_USER'
    payload:
      user: obj.user || obj || null
      authenticationTime: obj.timestamp || timestamp
  signup: (data) ->
    type: 'SIGNUP'
    payload:
      promise: API.signup data
