const expect = require('expect');

const R = require('ramda');
const { createMemoryHistory } = require('react-router');
const YAML = require('js-yaml');

const createStore = require('../src/scripts/store.js');
const selectors = require('../src/scripts/selectors/articleSelectors.js');
const { read } = require('../lib/utils.js');

describe('articleSelectors', () => {
  describe('containerSelector', () => {
    it('returns articles from state', () => {
      const { store } = createStore(createMemoryHistory());
      const state = store.getState();
      state.articleState = state.articleState.merge({
        articles: [
          { _id: '_id' },
          { _id: '_id' },
        ],
      });
      const output = R.map(
        R.omit('urlParams'), selectors.containerSelector(state).articles
      );
      expect(output).toEqual(state.articleState.get('articles').toJS());
    });
  });
  describe('itemSelector', () => {
    it(
      `returns the article title merged with the title when a single article
        with a title is provided`,
      () => {
        const { store } = createStore(createMemoryHistory());
        let state = store.getState();
        const lang = state.localeState.get('lang');
        const localeStrings = YAML.safeLoad(read(`locales/${lang}.yaml`));
        store.dispatch({
          type: 'FETCH_LOCALE_STRINGS_FULFILLED',
          payload: { lang, data: localeStrings },
        });
        state = store.getState();
        state.articleState = state.articleState.merge({
          articles: [
            { _id: '_id', title: { nb: { format: '', text: 'Article Title' } } },
          ],
        });
        const output = selectors.itemSelector(state);
        const { title } = localeStrings;
        const articleTitle = state.articleState.getIn(
          ['articles', 0, 'title', lang, 'text']
        );
        expect(output.title).toBe(`${articleTitle} - ${title}`);
      }
    );
    it(
      'returns just the title when a single article without a title is provided',
      () => {
        const { store } = createStore(createMemoryHistory());
        let state = store.getState();
        const lang = state.localeState.get('lang');
        const localeStrings = YAML.safeLoad(read(`locales/${lang}.yaml`));
        store.dispatch({
          type: 'FETCH_LOCALE_STRINGS_FULFILLED',
          payload: { lang, data: localeStrings },
        });
        state = store.getState();
        state.articleState = state.articleState.merge({
          articles: [
            { _id: '_id', title: { nb: { format: '', text: '' } } },
          ],
        });
        const output = selectors.itemSelector(state);
        const { title } = localeStrings;
        expect(output.title).toBe(title);
      }
    );
  });
});
