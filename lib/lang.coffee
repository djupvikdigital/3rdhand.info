locale = require 'locale'
tags = require 'language-tags'

utils = require '../src/scripts/utils.coffee'

supportedLocales = [ 'nb', 'en' ]
supportedLocalesObject = new locale.Locales supportedLocales.join ','

isLanguage = (lang) ->
  typeof lang == 'string' && !!tags.language(lang)

isMacrolanguage = (lang) ->
  isLanguage(lang) && tags.language(lang).scope() == 'macrolanguage'

negotiateLang = utils.maybe (lang) ->
  if isMacrolanguage lang
    lang = tags.languages(lang)
  if Array.isArray lang
    lang = lang.join ','
  negotiated = (new locale.Locales(lang)).best(supportedLocalesObject)
  if negotiated.defaulted then return ''
  negotiated.toString()

module.exports = {
  isLanguage
  negotiateLang
  supportedLocales
}
