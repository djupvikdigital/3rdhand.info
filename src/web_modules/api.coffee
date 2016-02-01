request = require 'superagent'
require('superagent-as-promised')(request, Promise)
defaults = require 'json-schema-defaults'

articleSchema = require '../../schema/article-schema.yaml'
URL = require '../scripts/url.coffee'

articleDefaults = defaults articleSchema

if typeof __SERVER__ == 'undefined'
  __SERVER__ = ''

getBody = (res) ->
  res.body

module.exports =
  changePassword: (userId, data) ->
    request
      .post __SERVER__ + URL.getUserPath userId
      .accept 'application/json'
      .send data
  fetchArticles: (params) ->
    request
      .get __SERVER__ + URL.getPath params
      .accept 'application/json'
      .then getBody
  fetchLocaleStrings: (lang) ->
    request __SERVER__ + '/locales/' + lang
      .accept 'application/json'
      .then getBody
  getArticleDefaults: ->
    Object.assign {}, articleDefaults
  login: (data) ->
    request
      .post __SERVER__ + '/users'
      .accept 'application/json'
      .send data
      .then getBody
  logout: (userId) ->
    request
      .get __SERVER__ + URL.getUserPath(userId) + '/logout'
      .accept 'application/json'
  requestPasswordReset: (data) ->
    if !data.email
      return Promise.reject new Error('no email provided')
    request
      .post __SERVER__ + '/users'
      .accept 'application/json'
      .send data
  saveArticle: (article, userId) ->
    now = (new Date()).toISOString()
    article.created = now unless article.created
    # might add support for drafts/unpublished articles later
    article.published = now unless article.published
    if !article.updated
      article.updated = []
    article.updated[article.updated.length] = now
    request
      .post __SERVER__ + URL.getUserPath userId
      .accept 'application/json'
      .send article
  signup: (data) ->
      request
        .post __SERVER__ + '/signup'
        .accept 'application/json'
        .send data
