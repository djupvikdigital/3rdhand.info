const Immutable = require('immutable');
const t = require('transducers.js');

const URL = require('urlHelpers');
const utils = require('../utils.js');

const supportedLangParams = ['en', 'no'];

function getUrlToParams(params) {
  return [URL.getPath(params), params];
}

function getNewParams() {
  const now = new Date();
  return {
    year: now.getFullYear(),
    month: now.getMonth() + 1,
    day: now.getDate(),
    slug: 'untitled',
    view: 'new',
  };
}

const params = {
  changePassword: {
    slug: 'change-password',
  },
  home: {},
  logout: {
    slug: 'logout',
  },
  newArticle: getNewParams(),
};

function getUrlsToParams(currentParams) {
  return Object.assign(
    t.seq(
      params,
      t.map(pair => (
        getUrlToParams(URL.getNextParams({ currentParams, params: pair[1] }))
      ))
    ),
    t.toObj(
      supportedLangParams,
      t.map(langParam => (
        getUrlToParams(
          URL.getNextParams({ currentParams, langParam, params: currentParams })
        )
      ))
    )
  );
}

function setCurrentParams(state, payload) {
  return state
    .set('currentParams', Immutable.Map(payload))
    .mergeIn(['urlsToParams'], getUrlsToParams(payload));
}

function addUserParams(state, { user }) {
  if (user && user._id) {
    const currentParams = state.get('currentParams');
    return setCurrentParams(
      state,
      currentParams.set('userId', utils.getUserId(user._id)).toJS()
    );
  }
  return state;
}

function getArticleUrlsToParams(currentParams, articles) {
  return t.toObj(
    articles,
    t.map(({ urlParams }) => (
      getUrlToParams(URL.getNextParams({ currentParams, params: urlParams }))
    ))
  );
}

function removeUserParams(state) {
  const currentParams = state.get('currentParams');
  return setCurrentParams(state, currentParams.delete('userId').toJS());
}

const initialState = Immutable.fromJS({
  currentParams: {},
  params,
  urlsToParams: {
    '/': {},
    '/login': {},
  },
});

const reducers = {
  FETCH_ARTICLES_FULFILLED: (state, { docs }) => (
    state.mergeIn(
      ['urlsToParams'],
      getArticleUrlsToParams(state.get('currentParams'), docs)
    )
  ),
  LOGIN_FULFILLED: addUserParams,
  LOGOUT_PENDING: removeUserParams,
  SESSION_TIMEOUT: removeUserParams,
  SET_CURRENT_PARAMS: setCurrentParams,
  SET_LOGGEDIN_USER: addUserParams,
  INIT: (state, payload) => state.merge(payload.state.appState),
};

function articleReducer(_state, { type, payload }) {
  const state = _state || initialState;
  if (typeof reducers[type] == 'function') {
    return reducers[type](state, payload);
  }
  return state;
}

module.exports = articleReducer;
