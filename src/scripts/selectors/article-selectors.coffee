Immutable = require 'immutable'
moment = require 'moment-timezone'
Reselect = require 'reselect'
{ compose } = require 'transducers.js'

utils = require '../utils.coffee'
formatters = require '../formatters.coffee'
API = require 'api'
appSelectors = require './appSelectors.js'

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
        moment.tz(published.utc, published.timezone).format('LLL z')
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
    articleSelector
    langSelector
    compose prop('title'), appSelectors.titleSelector
  ]
  (state, lang, title) ->
    if state.article
      articleTitle = state.article.title
      if articleTitle && articleTitle[lang].text
        title = articleTitle[lang].text + ' - ' + title
    state.lang = lang
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
  formatSelector: formatSelector
  itemSelector: itemSelector
  editorSelector: Reselect.createSelector(
    [
      articleSelector
      langSelector
      appSelectors.localeSelector
    ]
    (state, lang, localeStrings) ->
      localeStrings = localeStrings.ArticleEditor
      articleTitle = state.article.title
      if articleTitle
        title = articleTitle[lang].text
      else
        title = localeStrings.untitled
      Object.assign {}, state, { title, lang, localeStrings }
  )
