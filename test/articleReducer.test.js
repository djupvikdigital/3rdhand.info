const expect = require('expect');

const Immutable = require('immutable');

const articleReducer = require('../src/scripts/reducers/articleReducer.js');
const utils = require('../src/scripts/utils.js');

describe('articleReducer', () => {
  it('can receive articles', () => {
    const state = Immutable.fromJS({
      articles: [
        { _id: '_id' },
      ],
      lang: 'en',
      error: null,
      refetch: false,
    });
    const newState = Immutable.fromJS({
      articles: [
        { _id: '_id' },
        { _id: '_id' },
      ],
      lang: 'en',
      error: null,
      refetch: false,
    });
    const action = {
      type: 'FETCH_ARTICLES_FULFILLED',
      payload: { docs: newState.get('articles').toJS() },
    };
    const output = articleReducer(state, action);
    expect(output.filterNot(utils.keyIn('lastUpdate')).toJS()).toEqual(
      newState.toJS()
    );
  });
});
