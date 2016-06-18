Immutable = require 'immutable'
t = require 'transducers.js'

URL = require 'url-helpers'
utils = require '../utils.coffee'

supportedLangParams = ['en', 'no']

getNewParams = ->
  now = new Date()
  return {
    year: now.getFullYear()
    month: now.getMonth() + 1
    day: now.getDate()
    slug: 'untitled'
    view: 'new'
  }

params =
  changePassword:
    slug: 'change-password'
  home: {}
  logout:
    slug: 'logout'
  newArticle: getNewParams()

getUrlsToParams = (currentParams) ->
  Object.assign(
    t.seq(
      params
      t.map (pair) ->
        nextParams = URL.getNextParams
          currentParams: currentParams
          params: pair[1]
        return [URL.getPath(nextParams), nextParams]
    )
    t.toObj(
      supportedLangParams
      t.map (langParam) ->
        nextParams = URL.getNextParams
          currentParams: currentParams
          params: currentParams
          langParam: langParam
        return [URL.getPath(nextParams), nextParams]
    )
  )

getArticleUrlsToParams = (currentParams, articles) ->
  t.toObj(
    articles,
    t.map (article) ->
      nextParams = URL.getNextParams
        currentParams: currentParams
        params: article.urlParams
      return [URL.getPath(nextParams), nextParams]
  )

initialState = Immutable.fromJS
  currentParams: {}
  params: params
  urlsToParams:
    '/': {}
    '/login': {}

addUserParams = (state, payload) ->
  if payload.user && payload.user._id
    currentParams = state.get 'currentParams'
    return setCurrentParams(
      state
      currentParams.set('userId', utils.getUserId payload.user._id).toJS()
    )
  else
    return state

removeUserParams = (state, payload) ->
  currentParams = state.get 'currentParams'
  return setCurrentParams state, currentParams.delete('userId').toJS()

setCurrentParams = (state, payload) ->
  state
    .set 'currentParams', Immutable.Map payload
    .mergeIn ['urlsToParams'], getUrlsToParams payload

reducers =
  FETCH_ARTICLES_FULFILLED: (state, payload) ->
    state.mergeIn(
      ['urlsToParams']
      getArticleUrlsToParams state.get('currentParams'), payload.docs
    )
  LOGIN_FULFILLED: addUserParams
  LOGOUT_PENDING: removeUserParams
  SESSION_TIMEOUT: removeUserParams
  SET_CURRENT_PARAMS: setCurrentParams
  SET_LOGGEDIN_USER: addUserParams
  INIT: (state, payload) ->
    state.merge payload.state.appState

module.exports = (state = initialState, action) ->
  if typeof reducers[action.type] == 'function'
    reducers[action.type](state, action.payload)
  else
    return state
