React = require 'react'
Helmet = React.createFactory require 'react-helmet'

{ formatSelector } = require '../selectors/article-selectors.coffee'
createFactory = require '../create-factory.coffee'
Elements = require '../elements.coffee'
URL = require 'urlHelpers'

{ div, h1, header, p, b } = Elements

module.exports = (props) ->
  lang = props.lang
  if !props.article || !props.article.title[lang].text
    return div()
  article = formatSelector props.article, lang
  { title, headline, summary, intro, body } = article
  pageTitle = props.title || title
  description = props.article.summary[lang].text
  url = props.serverUrl + URL.getPath article.urlParams
  div(
    Helmet
      title: pageTitle
      meta: [
        { name: 'description', content: description }
        { name: 'twitter:card', content: 'summary' }
        { name: 'twitter:site', content: '@thirdhandinfo' }
        { name: 'twitter:url', property: 'og:url', content: url }
        { name: 'twitter:title', property: 'og:title', content: pageTitle }
        {
          name: 'twitter:description'
          property: 'og:description'
          content: description
        }
      ]
    h1 innerHtml: headline || title
    if intro
      p b className: 'intro', innerHtml: intro
    div innerHtml: body
  )

module.exports.displayName = 'ArticleFull'
