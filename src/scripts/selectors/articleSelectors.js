const apply = require('ramda/src/apply');
const assoc = require('ramda/src/assoc');
const compose = require('ramda/src/compose');
const curry = require('ramda/src/curry');
const has = require('ramda/src/has');
const lens = require('ramda/src/lens');
const moment = require('moment-timezone');
const map = require('ramda/src/map');
const merge = require('ramda/src/merge');
const over = require('ramda/src/over');
const path = require('ramda/src/path');
const prop = require('ramda/src/prop');
const props = require('ramda/src/props');
const propOr = require('ramda/src/propOr');
const Reselect = require('reselect');
const when = require('ramda/src/when');

const API = require('api');
const appSelectors = require('./appSelectors.js');
const formatters = require('../formatters.js');
const URL = require('urlHelpers');
const utils = require('../utils.js');

const assocWhen = curry((key, value, obj) => {
  if (value) {
    return assoc(key, value, obj);
  }
  return obj;
});

const formatMapper = apply(utils.createFormatMapper(formatters));

const hasAll = curry((keys, obj) => (
  keys.every(Object.prototype.hasOwnProperty, obj)
));

function langSelector(state) {
  return state.localeState.get('lang');
}

const formatSelector = curry((lang, state) => {
  moment.locale(lang);
  const publishedLens = lens(
    propOr({}, 'published'),
    assocWhen('publishedFormatted')
  );
  return map(
    compose(
      when(
        hasAll(['format', 'text']),
        compose(formatMapper, props(['format', 'text']))
      ),
      when(has(lang), prop(lang))
    ),
    assoc(
      'urlParams',
      URL.getArticleParams(state),
      over(
        publishedLens,
        ({ utc, timezone }) => (
          utc && timezone && moment.tz(utc, timezone).format('LLL z')
        ),
        state
      )
    )
  );
});

const containerSelector = Reselect.createSelector(
  [state => state.articleState.toJS(), langSelector],
  (state, lang) => (
    merge(state, { articles: map(formatSelector(lang), state.articles) })
  )
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
    let { article } = state;
    let description = '';
    let title = _title;
    if (article) {
      const articleTitle = path(['title', lang, 'text'], article);
      if (articleTitle) {
        title = `${articleTitle} - ${title}`;
      }
      description = path(['summary', lang, 'text'], article);
    }
    article = formatSelector(lang, article);
    return merge(state, { article, description, title });
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
  itemSelector,
};
