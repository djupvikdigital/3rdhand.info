const find = require('ramda/src/find');
const Immutable = require('immutable');
const moment = require('moment');
const padStart = require('lodash/padStart');

const utils = require('../scripts/utils.js');

function assemblePath(_obj) {
  if (!Array.isArray(_obj.path) || !Array.isArray(_obj.filename)) {
    throw new Error('invalid object');
  }
  const obj = Object.assign({}, _obj);
  obj.path.pop();
  if (obj.path[0]) {
    obj.path.unshift('');
  }
  obj.filename = obj.filename.filter(Boolean);
  return [obj.path.join('/'), obj.filename.join('.')].join('/');
}

function getUserPath(userId) {
  return userId ? `/users/${utils.getUserId(userId)}` : '';
}

function setUserInArray(_arr, userId) {
  const i = _arr.indexOf('users');
  let arr = _arr.slice(0);
  if (i !== -1) {
    arr.splice(i, 0, userId);
  }
  else {
    if (!arr[0]) {
      arr.unshift('');
    }
    arr = ['users', userId].concat(arr);
  }
  return arr;
}

function addLangToArray(_arr, lang) {
  let arr = _arr;
  if (lang) {
    arr = arr.slice(0);
    arr[arr.length] = lang;
  }
  return arr;
}

const encodeMaybe = utils.maybe(encodeURIComponent);

function getPath(params) {
  const dateKeys = ['year', 'month', 'day'];
  const keys = dateKeys.concat(['slug', 'view']);
  let path = keys.map(k => {
    let param;
    if (params[k] && dateKeys.indexOf[k] !== -1) {
      param = padStart(params[k], 2, '0');
    }
    else {
      param = params[k];
    }
    return encodeMaybe(param);
  });
  path = path.filter(Boolean);
  if (params.userId) {
    path = setUserInArray(path, params.userId);
  }
  let filename = [path[path.length - 1]];
  filename = addLangToArray(filename, params.lang);
  return assemblePath({ path, filename });
}

function getArticleParams(article) {
  const dateFields = ['published', 'created'];
  const dateField = find(
    Object.prototype.hasOwnProperty.bind(article),
    dateFields
  );
  const date = moment.utc(dateField ? article[dateField].utc : new Date());
  return {
    year: date.year(),
    month: date.month() + 1,
    day: date.date(),
    slug: article.slug,
  };
}

function getServerUrl() {
  return `${location.protocol}//${location.host}`;
}

function getNextParams({ currentParams, langParam, params, slug }) {
  return Immutable.Map(currentParams || {})
    .filter(utils.keyIn('userId', 'lang'))
    .set('slug', slug)
    .merge(params || {})
    .update('lang', v => langParam || v)
    .toJS();
}

module.exports = {
  getArticleParams, getNextParams, getPath, getServerUrl, getUserPath,
};
