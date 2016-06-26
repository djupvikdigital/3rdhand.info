expect = require 'expect'

URL = require '../src/node_modules/urlHelpers.js'

describe 'URL modules', ->
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

  describe 'splitPath', ->
    it 'splits a path into an object with path and filename arrays', ->
      path = '/2015/09/29/slug.no'
      test =
        path: [
          ''
          '2015'
          '09'
          '29'
          'slug'
        ]
        filename: [
          'slug'
          'no'
        ]
      expect(URL.splitPath path).toEqual test
