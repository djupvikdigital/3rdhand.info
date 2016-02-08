ReduxRouter = require 'react-router-redux'

API = require 'api'
utils = require '../utils.coffee'
URL = require 'url-helpers'
appActions = require './app-actions.coffee'

module.exports =
  sessionTimeout: ->
    type: 'SESSION_TIMEOUT'
  login: (data) ->
    type: 'LOGIN'
    payload:
      promise: API.login(data).then (body) ->
        (action, dispatch) ->
          params = if data.from then JSON.parse(data.from) else {}
          params.userId = utils.getUserId body.user._id
          dispatch ReduxRouter.routeActions.push(
            pathname: URL.getPath(params), state: params
          )
          action.payload = body
          dispatch action
  logout: (data) ->
    type: 'LOGOUT'
    payload:
      promise: API.logout(data.userId).then ->
        (action, dispatch) ->
          params = if data.from then JSON.parse data.from else {}
          delete params.userId
          dispatch ReduxRouter.routeActions.push(
            pathname: URL.getPath(params), state: params
          )
          dispatch action
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
