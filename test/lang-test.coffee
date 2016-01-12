expect = require 'expect'

Lang = require '../lang.coffee'

describe 'Lang module', ->
	describe 'negotiateLang', ->
		it 'negotiates macrolanguages', ->
			lang = 'no'
			expect(Lang.negotiateLang lang).toBe 'nb'
		it 'returns the empty string if locale doesn\'t resolve to a supported locale', ->
			lang = 'new'
			expect(Lang.negotiateLang lang).toBe ''
