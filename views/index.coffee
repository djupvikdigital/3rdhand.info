React = require 'react'

Elements = require '../src/scripts/elements.coffee'

production = process.env.NODE_ENV == 'production'

assetPaths =
  scripts:
    js: '/scripts.js'
  styles:
    css: '/styles.css'
server = ''
if production
  assetPaths = require '../dist/webpack-assets.json'
else
  server = 'http://localhost:8080'

{ html, head, meta, title, link, body, header, div, script } = Elements

googleFontsUrl = 'http://fonts.googleapis.com/css?family='

module.exports = React.createClass
  render: ->
    html(
      { lang: @props.lang }
      head(
        meta(charSet: "utf-8")
        meta(
          name: "viewport"
          content: "width=device-width, initial-scale=1"
        )
        title(@props.title)
        link(
          rel: "stylesheet"
          href: googleFontsUrl + "Open+Sans:400,400italic,700,700italic,800italic"
        )
        link(
          rel: "stylesheet"
          href: googleFontsUrl + "Rokkitt:400,700"
        )
        link(
          rel: "stylesheet"
          href: server + assetPaths.styles.css
        )
      )
      body(
        div(id: "app", innerHtml: @props.app)
        script
          id: 'state', type: 'application/json'
          JSON.stringify @props.state
        script src: server + assetPaths.scripts.js
      )
    )
