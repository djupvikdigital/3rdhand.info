React = require 'react'
Helmet = React.createFactory require 'react-helmet'

createFactory = require '../create-factory.coffee'
Elements = require '../elements.coffee'

{ div, h1, header, p, b } = Elements

module.exports = (props) ->
  if !props.article
    return div()
  { title, headline, summary, intro, body } = props.article
  div(
    Helmet
      title: props.title || title
      meta: [
        name: 'description', content: summary
      ]
    h1 innerHtml: headline || title
    if intro
      p b className: 'intro', innerHtml: intro
    div innerHtml: body
  )

module.exports.displayName = 'ArticleFull'
