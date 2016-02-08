Lang = require './lang.coffee'
URL = require '../src/node_modules/url-helpers.coffee'

module.exports = (req) ->
  l = Lang.supportedLocales
  lang = URL.splitPath(req.url).filename.filter(Lang.isLanguage)[0]
  Lang.negotiateLang(lang) || req.acceptsLanguages.apply(req, l)
