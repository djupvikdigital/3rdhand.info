const Immutable = require('immutable');

const initialState = Immutable.fromJS({
  title: {
    en: '3rdhand.info',
    nb: '3rdhand.info',
  },
  articles: [],
  error: null,
  prevParams: {},
  refetch: false,
});

const reducers = {
  FETCH_ARTICLES_PENDING(state, { params }) {
    return state.set('prevParams', params);
  },
  FETCH_ARTICLES_FULFILLED(state, { docs }) {
    return state.merge({
      articles: docs,
      error: null,
      lastUpdate: new Date(),
      refetch: false,
    });
  },
  FETCH_ARTICLES_REJECTED(state, payload) {
    return state.merge(Immutable.Map({
      articles: Immutable.List(),
      error: payload,
      lastUpdate: null,
      refetch: false,
    }));
  },
  LOGIN_FULFILLED(state) {
    const err = state.get('error');
    if (err && err.status === 404) {
      return state.set('refetch', true);
    }
    return state;
  },
  INIT(state, payload) {
    return state.merge(payload.state.articleState);
  },
};

function articleReducer(_state, { type, payload }) {
  const state = _state || initialState;
  if (typeof reducers[type] == 'function') {
    return reducers[type](state, payload);
  }
  return state;
}

module.exports = articleReducer;
