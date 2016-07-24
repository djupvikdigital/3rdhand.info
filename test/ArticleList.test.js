const expect = require('expect');

const cheerio = require('cheerio');
const ReactDOM = require('react-dom/server');
const ReactRedux = require('react-redux');
const { createMemoryHistory } = require('react-router');
const { createFactory } = require('react-elementary').default;

const createStore = require('../src/scripts/store.js');
const { containerSelector } = require(
  '../src/scripts/selectors/articleSelectors.js'
);
const ArticleList = createFactory(
  require('../src/scripts/views/ArticleList.js')
);

const Provider = createFactory(ReactRedux.Provider);

describe('ArticleList', () => {
  it('renders a list of articles', () => {
    const { store } = createStore(createMemoryHistory());
    const articles = [
      {
        _id: '_id1',
        published: { utc: '2016-02-07T19:54:00Z', timezone: 'UTC' },
      },
      {
        _id: '_id2',
        published: { utc: '2016-02-07T19:55:00Z', timezone: 'UTC' },
      },
    ];
    store.dispatch({
      type: 'FETCH_ARTICLES_FULFILLED',
      payload: { docs: articles },
    });
    const props = containerSelector(store.getState());
    const component = Provider({ store }, ArticleList(props));
    const html = ReactDOM.renderToStaticMarkup(component);
    const $ = cheerio.load(html);
    const els = $('article');
    expect(els.length).toBe(2);
  });
});
