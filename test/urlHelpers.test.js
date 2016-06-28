const expect = require('expect');

const URL = require('../src/node_modules/urlHelpers.js');

describe('URL modules', () => {
  describe('getParams', () => {
    it('returns a params object from a path', () => {
      const input = '/2015/09/29/slug/view';
      const test = {
        year: '2015',
        month: '09',
        day: '29',
        slug: 'slug',
        view: 'view',
      };
      expect(URL.getParams(input)).toEqual(test);
    });
    it('supports partial dates with slug and view', () => {
      const input = '/2015/09/slug/view';
      const test = {
        year: '2015',
        month: '09',
        slug: 'slug',
        view: 'view',
      };
      expect(URL.getParams(input)).toEqual(test);
    });
    it('supports a path with only year', () => {
      const input = '2015';
      const test = {
        year: '2015',
      };
      expect(URL.getParams(input)).toEqual(test);
    });
    it('supports a path with only slug', () => {
      const input = 'test';
      const test = {
        slug: 'test',
      };
      expect(URL.getParams(input)).toEqual(test);
    });
    it('supports a path with only lang', () => {
      const input  = '/en';
      const test = {
        lang: 'en',
      };
      expect(URL.getParams(input)).toEqual(test);
    });
  });
  describe('getPath', () => {
    it('can rebuild a path from params', () => {
      const path = '/2015/09/29/slug/view';
      const params = URL.getParams(path);
      expect(URL.getPath(params)).toBe(path);
    });
    it('supports a path with only year', () => {
      const path = '/2015';
      const params = {
        year: '2015',
      };
      expect(URL.getPath(params)).toBe(path);
    });
    it('supports a path with only lang', () => {
      const path = '/en';
      const params = {
        lang: 'en',
      };
      expect(URL.getPath(params)).toBe(path);
    });
  });
  describe('splitPath', () => {
    it('splits a path into an object with path and filename arrays', () => {
      const path = '/2015/09/29/slug.no';
      const test = {
        path: ['', '2015', '09', '29', 'slug'],
        filename: ['slug', 'no'],
      };
      expect(URL.splitPath(path)).toEqual(test);
    });
  });
});
