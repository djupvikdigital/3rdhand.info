const expect = require('expect');

const Immutable = require('immutable');
const { createMemoryHistory } = require('react-router');

const articleActions = require('../src/scripts/actions/articleActions.js');
const createStore = require('../src/scripts/store.js');

describe('store', () => {
  describe('localeState', () => {
    it('has a language', () => {
      const { store } = createStore(createMemoryHistory());
      const state = store.getState().localeState;
      expect(state.has('lang')).toBe(true);
      expect(typeof state.get('lang')).toBe('string');
    })
  });
  describe('articleState', () => {
    it('has a list of articles', () => {
      const { store } = createStore(createMemoryHistory());
      const state = store.getState().articleState;
      expect(state.has('articles')).toBe(true);
      expect(Immutable.List.isList(state.get('articles'))).toBe(true);
    });
  });
});
