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