YAML = require 'js-yaml'
React = require 'react'

{ read } = require '../lib/utils.coffee'
Elements = require '../src/scripts/elements.coffee'

conf = YAML.safeLoad read './config.yaml'

server = ''
if conf.assetServer
  server = '//' + conf.assetServer.hostname + ':' + conf.assetServer.port
assetPaths = conf.assetPaths || require '../dist/webpack-assets.json'

{ html, head, meta, title, link, body, header, div, script } = Elements

googleFontsUrl = '//fonts.googleapis.com/css?family='
stylesheets = [
  googleFontsUrl + 'Open+Sans:400,400italic,700,700italic,800italic'
  googleFontsUrl + 'Rokkitt:400,700'
  server + assetPaths.styles.css
]

module.exports = React.createClass
  render: ->
    metadata = [
      meta charSet: 'utf-8'
      meta name: 'viewport', content: 'width=device-width, initial-scale=1'
      title(@props.title)
      link
        rel: 'alternate'
        type: 'application/atom+xml'
        title: @props.title
        href: '/index.atom'
    ].concat stylesheets.map (href) ->
        link rel: 'stylesheet', href: href
    html(
      { lang: @props.lang }
      head metadata
      body(
        div id: 'app', innerHtml: @props.app
        script
          id: 'state', type: 'application/json'
          JSON.stringify @props.state
        script src: server + assetPaths.scripts.js
      )
    )
