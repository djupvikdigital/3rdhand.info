expect = require 'expect'

Lang = require '../lang.coffee'

describe 'Lang module', ->
	describe 'isLanguage', ->
		it 'returns true if input is a language', ->
			lang = 'nb'
			expect(Lang.isLanguage lang).toBe true
		it 'returns false if input is not a language', ->
			lang = 'foo'
			expect(Lang.isLanguage lang).toBe false
	describe 'negotiateLang', ->
		it 'negotiates macrolanguages', ->
			lang = 'no'
			expect(Lang.negotiateLang lang).toBe 'nb'
		it 'returns the empty string if locale doesn\'t resolve to a supported locale', ->
			lang = 'new'
			expect(Lang.negotiateLang lang).toBe ''
