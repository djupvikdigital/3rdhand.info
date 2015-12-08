URL = require './src/scripts/url.coffee'

module.exports = (req) ->
	l = URL.supportedLocales
	URL.negotiateLang(
		URL.getLang(req.url, l) || req.acceptsLanguages.apply(req, l)
	)