React = require 'react'
Router = require 'react-router'
ReactRedux = require 'react-redux'

linkSelector = require('../selectors/app-selectors.coffee').linkSelector

createFactory = require '../create-factory.coffee'
Elements = require '../elements.coffee'

Link = createFactory ReactRedux.connect(linkSelector)(Router.Link)
{ div, header, h1, time } = Elements

module.exports = (props) ->
  {
    urlParams
    title
    headline
    summary
    published
    publishedFormatted
  } = props.article
  div(
    header(
      h1(
        { className: 'article__heading' }
        Link params: urlParams, innerHtml: headline || title
      )
      time(
        { className: 'milli', dateTime: published.utc }
        publishedFormatted
      )
    )
    div innerHtml: summary
  )

module.exports.displayName = 'ArticleItem'
