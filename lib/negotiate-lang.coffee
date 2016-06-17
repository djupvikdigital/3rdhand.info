accepts = require 'accepts'

Lang = require './lang.coffee'
URL = require '../src/node_modules/url-helpers.coffee'

module.exports = (req) ->
  l = Lang.supportedLocales
  lang = URL.splitPath(req.url).filename.filter(Lang.isLanguage)[0]
  Lang.negotiateLang(lang) || accepts(req).languages(l) || l[0]
