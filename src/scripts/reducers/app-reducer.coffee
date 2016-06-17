Immutable = require 'immutable'
t = require 'transducers.js'

URL = require 'url-helpers'

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
  t.seq(
    params
    t.map (pair) ->
      nextParams = URL.getNextParams
        currentParams: currentParams
        params: pair[1]
      return [URL.getPath(nextParams), nextParams]
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

reducers =
  FETCH_ARTICLES_FULFILLED: (state, payload) ->
    state.mergeIn(
      ['urlsToParams']
      getArticleUrlsToParams state.get('currentParams'), payload.docs
    )
  SET_CURRENT_PARAMS: (state, payload) ->
    state
      .set 'currentParams', payload
      .mergeIn ['urlsToParams'], getUrlsToParams payload
  INIT: (state, payload) ->
    state.merge payload.state.appState

module.exports = (state = initialState, action) ->
  if typeof reducers[action.type] == 'function'
    reducers[action.type](state, action.payload)
  else
    return state
