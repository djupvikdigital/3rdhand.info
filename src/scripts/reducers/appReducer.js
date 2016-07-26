const fromPairs = require('ramda/src/fromPairs');
const Immutable = require('immutable');
const map = require('ramda/src/map');
const pipe = require('ramda/src/pipe');
const values = require('ramda/src/values');

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

const initialParams = {
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
    fromPairs(values(map(
      params => getUrlToParams(URL.getNextParams({ currentParams, params })),
      initialParams
    ))),
    fromPairs(
      map(langParam => (
        getUrlToParams(
          URL.getNextParams({ currentParams, langParam, params: currentParams })
        )
      ), supportedLangParams)
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
  return fromPairs(
    map(
      pipe(
        URL.getArticleParams,
        urlParams => (
          getUrlToParams(
            URL.getNextParams({ currentParams, params: urlParams })
          )
        )
      ),
      articles
    )
  );
}

function removeUserParams(state) {
  const currentParams = state.get('currentParams');
  return setCurrentParams(state, currentParams.delete('userId').toJS());
}

const initialState = Immutable.fromJS({
  currentParams: {},
  params: initialParams,
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
