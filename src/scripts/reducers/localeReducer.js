const Immutable = require('immutable');
const { UPDATE_LOCATION } = require('react-router-redux');

const utils = require('../utils.coffee');

const initialState = Immutable.fromJS({
  lang: 'nb',
  pendingLang: '',
  langMap: {},
  localeStrings: {
    nb: {
      SiteHeader: {},
      ArticleEditor: {},
      LangPicker: {},
      LoginDialog: {},
    },
  },
});

const reducers = {
  FETCH_LOCALE_STRINGS_PENDING(state, { lang }) {
    return state.set('pendingLang', lang);
  },
  FETCH_LOCALE_STRINGS_FULFILLED(_state, { data, lang }) {
    let state = _state;
    const pending = state.get('pendingLang');
    if (pending !== lang) {
      state = state.setIn(['langMap', pending], lang)
    }
    return state
      .mergeIn(['localeStrings', lang], data)
      .merge({ lang: lang, pendingLang: '', lastUpdate: new Date() });
  },
  [UPDATE_LOCATION](state, payload) {
    const location = payload.state ||{};
    let { lang } = location;
    if (!lang) {
      return state.set('lang', initialState.get('lang'));
    }
    if (state.get('langMap').has(lang)) {
      lang = state.getIn(['langMap', lang]);
    }
    if (state.get('lang') !== lang && state.get('localeStrings').has(lang)) {
      return state.set('lang', lang);
    }
    return state;
  },
  INIT(state, payload) {
    return state.merge(payload.state.localeState);
  },
};

function localeReducer(_state, { type, payload }) {
  const state = _state || initialState;
  if (typeof reducers[type] == 'function') {
    return reducers[type](state, payload);
  }
  return state;
}

module.exports = localeReducer;
