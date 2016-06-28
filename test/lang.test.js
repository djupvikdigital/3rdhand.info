const expect = require('expect');

const Lang = require('../lib/lang.js');

describe('Lang module', () => {
  describe('isLanguage', () => {
    it('returns true if input is a language', () => {
      const lang = 'nb';
      expect(Lang.isLanguage(lang)).toBe(true);
    });
    it('returns false if input is not a language', () => {
      const lang = 'foo';
      expect(Lang.isLanguage(lang)).toBe(false);
    });
  });
  describe('negotiateLang', () => {
    it('negotiates macrolanguages', () => {
      const lang = 'no';
      expect(Lang.negotiateLang(lang)).toBe('nb');
    })
    it(
      `returns the empty string if locale doesn't resolve to a supported locale`,
      () => {
        const lang = 'new';
        expect(Lang.negotiateLang(lang)).toBe('');
      }
    )
  });
});
