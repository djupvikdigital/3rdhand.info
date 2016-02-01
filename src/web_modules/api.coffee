request = require 'superagent'
require('superagent-as-promised')(request, Promise)
defaults = require 'json-schema-defaults'

articleSchema = require '../../schema/article-schema.yaml'
URL = require '../scripts/url.coffee'

articleDefaults = defaults articleSchema

getBody = (res) ->
  res.body

module.exports =
  changePassword: (userId, data) ->
    request
      .post URL.getUserPath userId
      .accept 'application/json'
      .send data
  fetchArticles: (params) ->
    request
      .get URL.getPath params
      .accept 'application/json'
      .then getBody
  fetchLocaleStrings: (lang) ->
    request '/locales/' + lang
      .accept 'application/json'
      .then getBody
  getArticleDefaults: ->
    Object.assign {}, articleDefaults
  login: (data) ->
    request
      .post '/users'
      .accept 'application/json'
      .send data
      .then getBody
  logout: (userId) ->
    request
      .get URL.getUserPath(userId) + '/logout'
      .accept 'application/json'
  requestPasswordReset: (data) ->
    if !data.email
      return Promise.reject new Error('no email provided')
    request
      .post '/users'
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
      .post URL.getUserPath userId
      .accept 'application/json'
      .send article
  signup: (data) ->
      request
        .post '/signup'
        .accept 'application/json'
        .send data
