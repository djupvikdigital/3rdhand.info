const expect = require('expect');

const Lang = require('../lib/lang.js');
const negotiateLang = require('../lib/negotiateLang.js');

function createRequest(lang) {
  return {
    url: '/',
    headers: {
      'accept-language': lang,
    },
  };
}

describe('negotiateLang', () => {
  it(
    'negotiates a language based on a req object with an Accept-Language header',
    () => {
      let test = createRequest('nb, en');
      let expected = 'nb';
      let actual = negotiateLang(test);
      expect(actual).toBe(expected);
      test = createRequest('en, nb');
      expected = 'en';
      actual = negotiateLang(test);
      expect(actual).toBe(expected);
    }
  );
  it('returns the default locale when no language matches', () => {
    const test = createRequest('da');
    const expected = Lang.supportedLocales[0];
    const actual = negotiateLang(test);
    expect(actual).toBe(expected);
  })
});
