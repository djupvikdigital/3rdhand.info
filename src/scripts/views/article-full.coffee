React = require 'react'
Helmet = React.createFactory require 'react-helmet'

{ formatSelector } = require '../selectors/article-selectors.coffee'
createFactory = require '../create-factory.coffee'
Elements = require '../elements.coffee'

{ div, h1, header, p, b } = Elements

module.exports = (props) ->
  if !props.article
    return div()
  lang = props.lang
  article = formatSelector props.article, lang
  { title, headline, summary, intro, body } = article
  div(
    Helmet
      title: props.title || title
      meta: [
        name: 'description', content: props.article.summary[lang].text
      ]
    h1 innerHtml: headline || title
    if intro
      p b className: 'intro', innerHtml: intro
    div innerHtml: body
  )

module.exports.displayName = 'ArticleFull'
