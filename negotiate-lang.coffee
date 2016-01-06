Lang = require './lang.coffee'
URL = require './url.coffee'

module.exports = (req) ->
	l = Lang.supportedLocales
	lang = URL.splitPath(req.url).filename.filter(Lang.isLanguage)[0]
	Lang.negotiateLang lang || req.acceptsLanguages.apply(req, l)
