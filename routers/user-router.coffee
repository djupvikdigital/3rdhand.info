YAML = require 'js-yaml'
router = require('express').Router()
session = require 'cookie-session'
moment = require 'moment'
URL = require 'url'

logger = require '../lib/log.coffee'
utils = require '../lib/utils.coffee'
API = require '../src/node_modules/api.coffee'
DB = require '../lib/db.coffee'
createStore = require '../src/scripts/store.coffee'
userActions = require '../src/scripts/actions/user-actions.coffee'
articleActions = require '../src/scripts/actions/article-actions.coffee'
siteRouter = require './site-router.coffee'
{
  getPath
  getUserPath
  getServerUrl
} = require '../src/node_modules/url-helpers.coffee'

conf = YAML.safeLoad utils.read './config.yaml'

clearUserSession = (req) ->
  if !req
    throw new Error('missing required argument')
  if req.session
    req.session = null

router.use session(
  name: 'session'
  secret: conf.serverSecret
  httpOnly: true
)

router.post '/', (req, res) ->
  data = req.body
  if data.resetPassword
    API.requestPasswordReset data, getServerUrl req
      .then res.send.bind res
      .catch (err) ->
        msg = err.message
        if msg == 'no email provided'
          res.status(400).send message: msg
        else if msg == 'no user match'
          logger.warn msg
          res.status(400).send message: 'invalid email or password'
        else
        logger.error err
        res.sendStatus 500
  else
    { store } = createStore()
    store.dispatch userActions.login data
      .payload.promise.then (action) ->
        { user, timestamp } = action.payload
        if action.error
          return Promise.reject action.payload
        req.session.user = user
        req.session.timestamp = timestamp
        res.format
          html: ->
            res.redirect 303, getUserPath user._id + data.from
          json: ->
            res.send action.payload
      .catch (err) ->
        msg = err.message
        if msg == 'no user match' || msg == 'authentication failed'
          logger.warn msg
          res.status(400).send message: 'invalid email or password'
        else
          logger.error err
          res.sendStatus 500

router.use '/:userId', (req, res, next) ->
  data = Object.assign {}, req.query, req.body, req.params
  if data.token && data.timestamp
    data = Object.assign {}, data, { path: req.baseUrl + req.path }
    DB.authenticate data
      .then (user) ->
        req.user = user
        next()
      .catch next
  else
    timestamp = 0
    if req.session && req.session.timestamp
      timestamp = req.session.timestamp
      duration = moment.duration(Date.now() - timestamp)
    if !timestamp || duration.asMinutes() > 30
      # session timed out
      clearUserSession req
      err = new Error('session timeout')
      next err
    else
      req.session.timestamp = Date.now()
      next()

router.get '/:userId/logout', (req, res) ->
  clearUserSession req
  res.format
    html: ->
      path = '/'
      if req.query.from
        from = JSON.parse req.query.from
        delete from.userId
        path = getPath from
      else
        url = null
        referrer = req.get 'Referer'
        if referrer
          url = URL.parse referrer
        if url && url.hostname == req.hostname
          path = url.path
      res.redirect 303, getServerUrl(req) + path
    default: ->
      res.status(204).end()

router.post '/:userId', (req, res) ->
  data = req.body
  if data.changePassword
    API.changePassword req.params.userId, data
      .then res.send.bind res
      .catch (err) ->
        msg = err.message
        if msg == 'required fields missing' || msg == 'repeat password mismatch'
          logger.warn msg
          res.status(400).send message: msg
        else
          logger.error err
          res.sendStatus 500
  else
    { store } = createStore()
    store.dispatch articleActions.save data, req.session.user._id
      .payload.promise.then res.send.bind res
      .catch (err) ->
        msg = err.message
        if msg == 'login required'
          logger.warn msg
          res.sendStatus 404
        else if msg == 'permission denied'
          logger.warn msg
          res.sendStatus 403
        else
          logger.error err
          res.sendStatus 500

router.use '/:userId', siteRouter

module.exports = router
