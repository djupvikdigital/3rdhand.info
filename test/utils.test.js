const expect = require('expect');

const Immutable = require('immutable');

const formatters = require('../src/scripts/formatters.js');
const utils = require('../src/scripts/utils.js');

describe('utils module', () => {
  describe('argsToObject', () => {
    it(
      `returns a function that when given args it returns an object with those
        args mapped to provided property keys`,
      () => {
        const test = { foo: 'bar', baz: 'quux' };
        expect(utils.argsToObject('foo', 'baz')('bar', 'quux')).toEqual(test);
      }
    );
  });
  describe('array', () => {
    it('converts non-arrays to array', () => {
      const test = ['item1', 'item2'];
      expect(utils.array('item1', 'item2')).toEqual(test);
    });
    it('leaves an array alone', () => {
      const test = ['item1', 'item2'];
      expect(utils.array(test)).toEqual(test);
    })
  });
  describe('createFormatMapper', () => {
    it('returns text formatted from a format and a text', () => {
      const format = 'markdown';
      const text = 'Markdown *em*.';
      const test = '<p>Markdown <em>em</em>.</p>\n';
      expect(utils.createFormatMapper(formatters)(format, text)).toEqual(test);
    });
    it('returns just the text if there are no formatters', () => {
      const format = 'markdown';
      const text = 'Markdown *em*.';
      expect(utils.createFormatMapper()(format, text)).toEqual(text);
    });
  });
  describe('createPropertyMapper', () => {
    it(
      `takes a property key and a function, when applied to an object it sets
        the object key to the function return value`,
      () => {
        const input = { foo: 'bar' };
        const test = { foo: 'bar', baz: 'quux' };
        const fn = () => 'quux';
        expect(utils.createPropertyMapper('baz', fn).call(input)).toEqual(test);
      }
    );
    it('returns null if the property key already exists', () => {
      const input = { foo: 'bar' };
      const test = { foo: 'bar', baz: 'quux' };
      const fn = () => 'baz';
      expect(utils.createPropertyMapper('foo', fn).call(input)).toBe(null);
    });
  });
  describe('getUserId', () => {
    it('returns the cuid portion of a user id', () => {
      const input = 'user/foo';
      expect(utils.getUserId(input)).toBe('foo');
    });
    it('returns the input if the string is not prefixed with "user/"', () => {
      const input = 'bar';
      expect(utils.getUserId(input)).toBe('bar');
    });
    describe('keyIn', () => {
      it(
        `returns a filter function that can filter an Immutable.Map by a set of
          keys`,
        () => {
          const input = Immutable.Map({
            foo: 'bar',
            bar: 'baz',
            baz: 'quux',
          });
          const test = Immutable.Map({
            foo: 'bar',
            bar: 'baz',
          });
          expect(Immutable.is(input.filter(utils.keyIn('foo', 'bar')), test))
            .toBe(true);
        }
      );
    });
    describe('mapObjectRecursively', () => {
      it(
        `takes mapper functions and goes over the object recursively, applying
          to objects with provided props`,
        () => {
          const input = {
            foo: { bar: 1 },
            baz: [
              { foo: 1, bar: 2 },
              { foo: 1, baz: 1 },
            ],
          };
          const test = {
            foo: 2,
            baz: [
              3,
              { foo: 1, baz: 1 },
            ],
          }
          const mapper1 = (foo, bar) => foo + bar;
          const mapper2 = bar => bar + 1;
          const args = [
            input,
            ['foo', 'bar', mapper1],
            ['bar', mapper2],
          ];
          expect(utils.mapObjectRecursively(...args)).toEqual(test);
        }
      );
    });
  });
  describe('maybe', () => {
    it(
      'applies a function only if argument is truthy, else it returns null',
      () => {
        let input = true;
        const fn = utils.maybe(() => 'success');
        expect(fn(input)).toBe('success');
        input = false;
        expect(fn(input)).toBe(null);
      }
    );
  });
  describe('stripDbFields', () => {
    it('removes fields _id and _rev from an object', () => {
      const input = {
        _id: 'id',
        _rev: 'rev',
        field: 'field',
      };
      const test = { field: 'field' };
      expect(utils.stripDbFields(input)).toEqual(test);
    });
    it('returns an Immutable.Map if provided an Immutable.Map', () => {
      const input = Immutable.Map({ field: 'field' });
      const output = utils.stripDbFields(input);
      expect(Immutable.Map.isMap(output)).toBe(true);
    });
  });
});
