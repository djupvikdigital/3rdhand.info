const Immutable = require('immutable');
const t = require('transducers.js');

const URL = require('urlHelpers');
const utils = require('../utils.js');

const supportedLangParams = ['en', 'no'];

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
    t.map(article => {
      const params = article.urlParams;
      return getUrlToParams(URL.getNextParams({ currentParams, params }));
    })
  );
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

function getUrlToParams(params) {
  return [URL.getPath(params), params];
}

function getUrlsToParams(currentParams) {
  return Object.assign(
    t.seq(
      params,
      t.map(pair => {
        const params = pair[1];
        return getUrlToParams(URL.getNextParams({ currentParams, params }));
      })
    ),
    t.toObj(
      supportedLangParams,
      t.map(langParam => {
        const params = currentParams;
        return getUrlToParams(URL.getNextParams({
          currentParams, langParam, params
        }));
      })
    )
  );
}

function removeUserParams(state, payload) {
  const currentParams = state.get('currentParams');
  return setCurrentParams(state, currentParams.delete('userId').toJS());
}

function setCurrentParams(state, payload) {
  return state
    .set('currentParams', Immutable.Map(payload))
    .mergeIn(['urlsToParams'], getUrlsToParams(payload));
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

const initialState = Immutable.fromJS({
  currentParams: {},
  params: params,
  urlsToParams: {
    '/': {},
    '/login': {},
  },
});

const reducers = {
  FETCH_ARTICLES_FULFILLED: (state, { docs }) => {
    return state.mergeIn(
      ['urlsToParams'],
      getArticleUrlsToParams(state.get('currentParams'), docs)
    );
  },
  LOGIN_FULFILLED: addUserParams,
  LOGOUT_PENDING: removeUserParams,
  SESSION_TIMEOUT: removeUserParams,
  SET_CURRENT_PARAMS: setCurrentParams,
  SET_LOGGEDIN_USER: addUserParams,
  INIT: (state, payload) => {
    return state.merge(payload.state.appState);
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
