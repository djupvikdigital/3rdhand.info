React = require 'react'
ReactRedux = require 'react-redux'
Immutable = require 'immutable'

createFactory = require '../create-factory.coffee'

actions = require '../actions/articleActions.js'
{ loginSelector } = require '../selectors/app-selectors.coffee'
selectors = require '../selectors/article-selectors.coffee'
authenticate = require './authenticate.coffee'

ArticleList = createFactory require './article-list.coffee'
ArticleFull = createFactory(
  ReactRedux.connect(selectors.itemSelector)(require './article-full.coffee')
)
ArticleEditor = createFactory(
  ReactRedux.connect(loginSelector)(
    authenticate ReactRedux.connect(selectors.editorSelector)(
      require './article-editor.coffee'
    )
  )
)

module.exports = React.createClass
  displayName: 'ArticleContainer'
  fetch: (params, force = false) ->
    prevParams = Immutable.Map @props.prevParams
    if force || !Immutable.is prevParams, Immutable.Map params
      @props.dispatch actions.fetch(params)
  save: (data) ->
    @props.dispatch actions.save data, @props.login.user._id
  componentWillMount: ->
    @fetch @props.params
  componentWillReceiveProps: (nextProps) ->
    @fetch nextProps.params, nextProps.refetch
  render: ->
    params = @props.params || {}
    articles = @props.articles
    if articles.length > 1
      ArticleList articles: articles
    else if params.view
      ArticleEditor save: @save, params: params
    else
      ArticleFull serverUrl: @props.serverUrl
