const defaults = require('json-schema-defaults');
const moment = require('moment-timezone');
const request = require('superagent');
require('superagent-as-promised')(request, Promise);

const articleSchema = require('../../schema/article-schema.yaml');
const URL = require('./urlHelpers.js');

const articleDefaults = defaults(articleSchema);

const json = 'application/json';

function createDatetimeStruct(date) {
  return {
    utc: moment.utc(date).toISOString(),
    timezone: moment.tz.guess(),
  };
}

function getBody(res) {
  return res.body;
}

// Public API

function changePassword(userId, data) {
  return request.post(URL.getUserPath(userId)).accept(json).send(data);
}

function fetchArticles(params) {
  return request.get(URL.getPath(params)).accept(json).then(getBody);
}

function fetchLocaleStrings(lang) {
  return request(`/locales/${lang}`).accept(json).then(getBody);
}

function getArticleDefaults() {
  return Object.assign({}, articleDefaults);
}

function login(data) {
  return request.post('/users').accept(json).send(data)
    .then(getBody);
}

function logout(userId) {
  return request.get(`${URL.getUserPath(userId)}/logout`).accept(json);
}

function requestPasswordReset(data) {
  if (!data.email) {
    return Promise.reject(new Error('no email provided'));
  }
  return request.post('/users').accept(json).send(data);
}

function saveArticle(_article, userId) {
  const now = createDatetimeStruct(new Date());
  const article = Object.assign({}, _article);
  if (!article.created) {
    article.created = now;
  }
  if (!article.published) {
    article.published = now;
  }
  if (!article.updated) {
    article.updated = [];
  }
  article.updated.push(now);
  return request.post(URL.getUserPath(userId)).accept(json).send(article);
}

function signup(data) {
  return request.post('/signup').accept(json).send(data);
}

module.exports = {
  changePassword,
  fetchArticles,
  fetchLocaleStrings,
  getArticleDefaults,
  login,
  logout,
  requestPasswordReset,
  saveArticle,
  signup,
};
