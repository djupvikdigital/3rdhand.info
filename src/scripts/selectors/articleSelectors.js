const assoc = require('ramda/src/assoc');
const compose = require('ramda/src/compose');
const moment = require('moment-timezone');
const merge = require('ramda/src/merge');
const path = require('ramda/src/path');
const prop = require('ramda/src/prop');
const Reselect = require('reselect');

const API = require('api');
const appSelectors = require('./appSelectors.js');
const formatters = require('../formatters.js');
const utils = require('../utils.js');

function langSelector(state) {
  return state.localeState.get('lang');
}

function formatSelector(state, lang) {
  moment.locale(lang);
  return utils.mapObjectRecursively(
    state,
    [lang, (x => x)],
    ['format', 'text', utils.createFormatMapper(formatters)],
    [
      'published',
      utils.createPropertyMapper('publishedFormatted', ({ utc, timezone }) => (
        moment.tz(utc, timezone).format('LLL z')
      )),
    ]
  );
}

const containerSelector = Reselect.createSelector(
  [state => state.articleState.toJS(), langSelector], formatSelector
);

function articleSelector(_state) {
  const state = _state.articleState.toJS();
  const { articles } = state;
  const article = articles.length ? articles[0] : API.getArticleDefaults();
  return { article };
}

// Public API

const itemSelector = Reselect.createSelector(
  [
    articleSelector,
    langSelector,
    compose(prop('title'), appSelectors.titleSelector),
  ],
  (state, lang, _title) => {
    const { article } = state;
    let title = _title;
    if (article) {
      const articleTitle = path(['title', lang, 'text'], article);
      if (articleTitle) {
        title = `${articleTitle} - ${title}`;
      }
    }
    return merge(state, { lang, title });
  }
);

const editorSelector = Reselect.createSelector(
  [articleSelector, langSelector, appSelectors.localeSelector],
  (state, lang, _localeStrings) => {
    const localeStrings = _localeStrings.ArticleEditor;
    const articleTitle = state.article.title;
    const title = articleTitle ? articleTitle[lang].text : localeStrings.untitled;
    return Object.assign({}, state, { lang, localeStrings, title });
  }
);

const footerSelector = Reselect.createSelector(
  [
    compose(prop('ArticleFooter'), appSelectors.localeSelector),
    appSelectors.loginSelector,
  ],
  assoc('localeStrings')
);

module.exports = {
  containerSelector: Reselect.createSelector(
    [containerSelector, appSelectors.paramSelector],
    (state, params) => merge(state, { params })
  ),
  editorSelector,
  footerSelector,
  formatSelector,
  itemSelector,
};
