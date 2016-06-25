ReduxRouter = require 'react-router-redux'

URL = require 'urlHelpers'

module.exports =
  init: (state) ->
    type: 'INIT'
    payload: { state }
  mergeParams: (_params) ->
    (dispatch, getState) ->
      params = Object.assign {}, getState().routing.state, _params
      dispatch ReduxRouter.routeActions.push(
        pathname: URL.getPath(params), state: params
      )
  setCurrentParams: (payload) ->
    return { type: 'SET_CURRENT_PARAMS', payload }
