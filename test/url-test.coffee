expect = require 'expect'

URL = require '../src/scripts/url.coffee'

describe 'URL module', ->
	describe 'getParams', ->
		it 'returns a params object from a path', ->
			input = '/2015/09/29/slug/view'
			test =
				year: '2015'
				month: '09'
				day: '29'
				slug: 'slug'
				view: 'view'
			expect(URL.getParams input).toEqual test
		it 'supports partial dates with slug and view', ->
			input = '/2015/09/slug/view'
			test =
				year: '2015'
				month: '09'
				slug: 'slug'
				view: 'view'
			expect(URL.getParams input).toEqual test
		it 'supports a path with only year', ->
			input = '2015'
			test =
				year: '2015'
			expect(URL.getParams input).toEqual test
		it 'supports a path with only slug', ->
			input = 'test'
			test =
				slug: 'test'
			expect(URL.getParams input).toEqual test
		it 'supports a path with only lang', ->
			input = '/en'
			test =
				lang: 'en'
			expect(URL.getParams input).toEqual test
	describe 'getPath', ->
		it 'can rebuild a path from params', ->
			path = '/2015/09/29/slug/view'
			params = URL.getParams path
			expect(URL.getPath params).toBe path
		it 'supports a path with only year', ->
			path = '/2015'
			params =
				year: '2015'
			expect(URL.getPath params).toBe path
		it 'supports a path with only lang', ->
			path = '/en'
			params =
				lang: 'en'
			expect(URL.getPath params).toBe path
	describe 'negotiateLang', ->
		it 'negotiates macrolanguages', ->
			lang = 'no'
			expect(URL.negotiateLang lang).toBe 'nb'
		it 'returns the empty string if locale doesn\'t resolve to a supported locale', ->
			lang = 'new'
			expect(URL.negotiateLang lang).toBe ''
