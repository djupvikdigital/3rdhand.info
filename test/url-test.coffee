expect = require 'expect'

createStore = require '../testutils/create-store.coffee'
URL = require '../src/scripts/url.coffee'

getSupportedLocales = ->
	createStore().getState().localeState.toJS().supportedLocales

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
			expect(URL.getParams input, getSupportedLocales()).toEqual test
		it 'supports a path with only lang', ->
			input = '/en'
			test =
				lang: 'en'
			expect(URL.getParams input, getSupportedLocales()).toEqual test
	describe 'getHref', ->
		it 'supports a path with only lang', ->
			path = '/en'
			params = URL.getParams path, getSupportedLocales()
			input = '/2015/09/29/'
			test = input + 'en'
			expect(URL.getHref input, params).toBe test
		it 'gives macrolanguage for macrolanguage', ->
			path = '/no'
			params = URL.getParams path, getSupportedLocales()
			input = '/test'
			test = input + '.no'
			expect(URL.getHref input, params).toBe test