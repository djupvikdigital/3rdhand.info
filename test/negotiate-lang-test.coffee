expect = require 'expect'

Lang = require '../lib/lang.coffee'
negotiateLang = require '../lib/negotiate-lang.coffee'

createRequest = (lang) ->
  return {
    url: '/'
    headers:
      'accept-language': lang
  }

describe 'negotiateLang', ->
  it 'negotiates a language based on a req object with an Accept-Language header', ->
    test = createRequest 'nb, en'
    expected = 'nb'
    actual = negotiateLang test
    expect(actual).toBe expected
    test = createRequest 'en, nb'
    expected = 'en'
    actual = negotiateLang test
    expect(actual).toBe expected
  it 'returns the default locale when no language matches', ->
    test = createRequest 'da'
    expected = Lang.supportedLocales[0]
    actual = negotiateLang test
    expect(actual).toBe expected
