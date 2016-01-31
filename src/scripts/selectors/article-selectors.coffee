Immutable = require 'immutable'
moment = require 'moment'
Reselect = require 'reselect'
{ compose } = require 'transducers.js'

utils = require '../utils.coffee'
formatters = require '../formatters.coffee'
API = require 'api'
appSelectors = require './app-selectors.coffee'

{ prop } = utils

langSelector = (state) ->
  state.localeState.get 'lang'

formatSelector = (state, lang) ->
  moment.locale lang
  utils.mapObjectRecursively(
    state
    [ lang, utils.identity ]
    [ 'format', 'text', utils.createFormatMapper(formatters) ]
    [ 
      'published'
      utils.createPropertyMapper 'publishedFormatted', (published) ->
        moment(published).format('LLL')
    ]
  )

containerSelector = Reselect.createSelector(
  [
    (state) ->
      state.articleState.toJS()
    langSelector
  ],
  formatSelector
)

articleSelector = (state) ->
  state = state.articleState.toJS()
  if state.articles.length
    article = state.articles[0]
  else
    article = API.getArticleDefaults()
  return {
    article: article
  }

itemSelector = Reselect.createSelector(
  [
    Reselect.createSelector(
      [ articleSelector, langSelector ]
      formatSelector
    )
    compose prop('title'), appSelectors.titleSelector
  ]
  (state, title) ->
    if state.article
      articleTitle = state.article.title
      if articleTitle
        title = articleTitle + ' - ' + title
    state.title = title
    state
)

module.exports =
  containerSelector: Reselect.createSelector(
    [
      containerSelector
      appSelectors.paramSelector
    ]
    (state, params) ->
      state.params = params
      state
  )
  itemSelector: itemSelector
  editorSelector: Reselect.createSelector(
    [
      articleSelector
      itemSelector
      langSelector
      appSelectors.localeSelector
    ]
    (state, item, lang, localeStrings) ->
      localeStrings = localeStrings.ArticleEditor
      title = item.article.title || localeStrings.untitled
      Object.assign {}, state, { title, lang, localeStrings }
  )
