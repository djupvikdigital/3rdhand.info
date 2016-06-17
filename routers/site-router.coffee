router = require('express').Router()
ReactRouter = require 'react-router'
ReduxRouter = require 'react-router-redux'

logger = require '../lib/log.coffee'
API = require '../src/node_modules/api.coffee'
renderTemplate = require '../lib/render-template.coffee'
negotiateLang = require '../lib/negotiate-lang.coffee'
createStore = require '../src/scripts/store.coffee'
userActions = require '../src/scripts/actions/user-actions.coffee'
createHandler = require '../lib/create-router-handler.coffee'
URL = require '../src/node_modules/url-helpers.coffee'
utils = require '../src/scripts/utils.coffee'

setUser = (session, userId, dispatch) ->
  if !userId then return false
  id = 'user/' + userId
  if session && session.user._id == id
    dispatch userActions.setUser utils.getUserProps session.user
    return true
  return false

router.get '*', createHandler (req, res, config) ->
  { params, props, storeModule } = config
  if !props
    throw new Error('no route match')
  res.format
    html: ->
      { store, history } = storeModule
      if req.user
        store.dispatch userActions.setUser utils.getUserProps req.user
      else
        setUser req.session, params.userId, store.dispatch
      renderTemplate config
        .then res.send.bind res
    default: ->
      API.fetchArticles params
        .then res.send.bind res
        .catch (err) ->
          logger.error err
          res.sendStatus 500

module.exports = router
